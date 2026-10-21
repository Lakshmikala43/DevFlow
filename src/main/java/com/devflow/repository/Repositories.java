package com.devflow.repository;

import com.devflow.model.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface Repositories {

    interface UserRepository extends JpaRepository<User, Long> {
        Optional<User> findByEmail(String email);
        boolean existsByEmail(String email);
        List<User> findByOrganizationId(Long organizationId);
    }

    interface OrganizationRepository extends JpaRepository<Organization, Long> {
        Optional<Organization> findBySlug(String slug);
    }

    interface ProjectRepository extends JpaRepository<Project, Long> {
        List<Project> findByOrganizationId(Long organizationId);
        Optional<Project> findByOrganizationIdAndProjectKey(Long organizationId, String projectKey);
        Page<Project> findByOrganizationId(Long organizationId, Pageable pageable);
    }

    interface TaskRepository extends JpaRepository<Task, Long> {
        List<Task> findByProjectId(Long projectId);
        Optional<Task> findByProjectIdAndTaskKey(Long projectId, String taskKey);
        List<Task> findByAssigneeId(Long assigneeId);
        List<Task> findByProjectIdAndStatus(Long projectId, Enums.TaskStatus status);
        
        @Query("SELECT COUNT(t) FROM Task t WHERE t.project.id = :projectId AND t.status = 'DONE'")
        long countDoneTasksByProject(@Param("projectId") Long projectId);

        @Query("SELECT COUNT(t) FROM Task t WHERE t.project.id = :projectId")
        long countTotalTasksByProject(@Param("projectId") Long projectId);
    }

    interface DeliverableRepository extends JpaRepository<Deliverable, Long> {
        List<Deliverable> findByProjectId(Long projectId);
        List<Deliverable> findByProjectIdAndApprovalStatus(Long projectId, Enums.ApprovalStatus status);
    }

    interface ApprovalRepository extends JpaRepository<Approval, Long> {
        List<Approval> findByDeliverableVersionId(Long deliverableVersionId);
        List<Approval> findByClientUserId(Long clientUserId);
    }

    interface ReleaseRepository extends JpaRepository<Release, Long> {
        List<Release> findByProjectId(Long projectId);
        Optional<Release> findByProjectIdAndVersionName(Long projectId, String versionName);
    }
}
