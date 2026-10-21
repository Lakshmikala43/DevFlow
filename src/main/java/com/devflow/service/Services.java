package com.devflow.service;

import com.devflow.model.*;
import com.devflow.repository.Repositories.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class Services {

    @Service
    @Transactional
    public static class AuthService {
        private final UserRepository userRepository;
        private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

        public AuthService(UserRepository userRepository) {
            this.userRepository = userRepository;
        }

        public User register(String email, String rawPassword, String fullName, Enums.Role role, Organization org) {
            if (userRepository.existsByEmail(email)) {
                throw new IllegalArgumentException("User with email " + email + " already exists");
            }
            String hashed = passwordEncoder.encode(rawPassword);
            User user = new User(email, hashed, fullName, role, org);
            return userRepository.save(user);
        }

        public Optional<User> authenticate(String email, String rawPassword) {
            return userRepository.findByEmail(email)
                .filter(u -> passwordEncoder.matches(rawPassword, u.getPasswordHash()));
        }

        public boolean verifyPassword(String rawPassword, String encodedHash) {
            return passwordEncoder.matches(rawPassword, encodedHash);
        }
    }

    @Service
    @Transactional
    public static class ProjectService {
        private final ProjectRepository projectRepository;

        public ProjectService(ProjectRepository projectRepository) {
            this.projectRepository = projectRepository;
        }

        public List<Project> getProjectsByOrg(Long orgId) {
            return projectRepository.findByOrganizationId(orgId);
        }

        public Project createProject(Project project) {
            return projectRepository.save(project);
        }

        public Optional<Project> getProject(Long id) {
            return projectRepository.findById(id);
        }

        public Project updateHealth(Long projectId, Enums.HealthStatus status) {
            Project p = projectRepository.findById(projectId)
                .orElseThrow(() -> new IllegalArgumentException("Project not found: " + projectId));
            p.setHealthStatus(status);
            return projectRepository.save(p);
        }
    }

    @Service
    @Transactional
    public static class ApprovalWorkflowService {
        private final DeliverableRepository deliverableRepository;
        private final ApprovalRepository approvalRepository;

        public ApprovalWorkflowService(DeliverableRepository deliverableRepository, ApprovalRepository approvalRepository) {
            this.deliverableRepository = deliverableRepository;
            this.approvalRepository = approvalRepository;
        }

        public Approval recordClientDecision(Long deliverableId, Long deliverableVersionId, User clientUser, Enums.ApprovalDecision decision, String feedback) {
            Deliverable deliverable = deliverableRepository.findById(deliverableId)
                .orElseThrow(() -> new IllegalArgumentException("Deliverable not found: " + deliverableId));

            if (decision == Enums.ApprovalDecision.REVISION_REQUESTED && (feedback == null || feedback.trim().isEmpty())) {
                throw new IllegalArgumentException("Revision requests strictly require detailed feedback comments.");
            }

            Approval approval = new Approval();
            approval.setDeliverableVersionId(deliverableVersionId);
            approval.setClientUser(clientUser);
            approval.setDecision(decision);
            approval.setFeedbackNotes(feedback);
            approval.setDecisionTimestamp(OffsetDateTime.now());

            Approval saved = approvalRepository.save(approval);

            if (decision == Enums.ApprovalDecision.APPROVED) {
                deliverable.setApprovalStatus(Enums.ApprovalStatus.APPROVED);
            } else if (decision == Enums.ApprovalDecision.REVISION_REQUESTED) {
                deliverable.setApprovalStatus(Enums.ApprovalStatus.REVISION_REQUESTED);
            }
            deliverableRepository.save(deliverable);

            return saved;
        }
    }

    @Service
    @Transactional(readOnly = true)
    public static class ReleaseReadinessService {
        private final ReleaseRepository releaseRepository;
        private final TaskRepository taskRepository;

        public ReleaseReadinessService(ReleaseRepository releaseRepository, TaskRepository taskRepository) {
            this.releaseRepository = releaseRepository;
            this.taskRepository = taskRepository;
        }

        public boolean evaluateReadiness(Long releaseId) {
            Release release = releaseRepository.findById(releaseId)
                .orElseThrow(() -> new IllegalArgumentException("Release not found: " + releaseId));

            long total = taskRepository.countTotalTasksByProject(release.getProject().getId());
            long done = taskRepository.countDoneTasksByProject(release.getProject().getId());

            // Gating rule: 100% tasks done or completion >= 90%
            boolean tasksReady = total == 0 || ((double) done / total) >= 0.90;
            return tasksReady;
        }
    }
}
