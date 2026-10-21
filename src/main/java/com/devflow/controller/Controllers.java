package com.devflow.controller;

import com.devflow.model.*;
import com.devflow.service.Services.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1")
@CrossOrigin(origins = "*")
public class Controllers {

    private final ProjectService projectService;
    private final ApprovalWorkflowService approvalService;
    private final ReleaseReadinessService releaseService;

    public Controllers(ProjectService projectService,
                       ApprovalWorkflowService approvalService,
                       ReleaseReadinessService releaseService) {
        this.projectService = projectService;
        this.approvalService = approvalService;
        this.releaseService = releaseService;
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> resp = new HashMap<>();
        resp.put("status", "UP");
        resp.put("platform", "DevFlow");
        resp.put("tagline", "From First Task to Final Release.");
        resp.put("version", "1.0.0");
        return ResponseEntity.ok(resp);
    }

    @GetMapping("/projects")
    public ResponseEntity<List<Project>> getProjects(@RequestParam(defaultValue = "1") Long orgId) {
        return ResponseEntity.ok(projectService.getProjectsByOrg(orgId));
    }

    @PostMapping("/projects")
    public ResponseEntity<Project> createProject(@RequestBody Project project) {
        return ResponseEntity.ok(projectService.createProject(project));
    }

    @GetMapping("/releases/{releaseId}/readiness")
    public ResponseEntity<Map<String, Object>> checkReadiness(@PathVariable Long releaseId) {
        boolean ready = releaseService.evaluateReadiness(releaseId);
        Map<String, Object> resp = new HashMap<>();
        resp.put("releaseId", releaseId);
        resp.put("isReadinessCleared", ready);
        resp.put("status", ready ? "READY_FOR_DEPLOY" : "BLOCKED_GATES_PENDING");
        return ResponseEntity.ok(resp);
    }
}
