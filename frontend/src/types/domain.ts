// DevFlow Comprehensive Domain Types Definition
export type Role = 'ADMIN' | 'PROJECT_MANAGER' | 'DEVELOPER' | 'QA_TESTER' | 'CLIENT';
export type ProjectStatus = 'PLANNING' | 'ACTIVE' | 'PAUSED' | 'COMPLETED' | 'ARCHIVED';
export type Priority = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
export type HealthStatus = 'ON_TRACK' | 'NEEDS_ATTENTION' | 'AT_RISK';
export type TaskStatus = 'BACKLOG' | 'TODO' | 'IN_PROGRESS' | 'IN_REVIEW' | 'DONE';
export type ApprovalStatus = 'DRAFT' | 'PENDING_REVIEW' | 'REVISION_REQUESTED' | 'APPROVED' | 'REJECTED';
export type ApprovalDecision = 'APPROVED' | 'REVISION_REQUESTED' | 'CONDITIONAL_ACCEPTANCE';
export type DefectSeverity = 'CRITICAL' | 'MAJOR' | 'MINOR' | 'COSMETIC';
export type DefectStatus = 'OPEN' | 'INVESTIGATING' | 'FIXED' | 'VERIFIED' | 'CLOSED';
export type ReleaseStatus = 'PLANNING' | 'STAGING' | 'READY_FOR_DEPLOY' | 'DEPLOYED' | 'CANCELLED';

export interface User {
  id: number;
  email: string;
  fullName: string;
  role: Role;
  organizationId: number;
  avatarUrl?: string;
  isActive: boolean;
  createdAt: string;
}

export interface Project {
  id: number;
  organizationId: number;
  projectKey: string;
  name: string;
  description: string;
  status: ProjectStatus;
  priority: Priority;
  healthStatus: HealthStatus;
  startDate?: string;
  targetDeliveryDate?: string;
  createdAt: string;
}

export interface Task {
  id: number;
  projectId: number;
  requirementId?: number;
  taskKey: string;
  title: string;
  description?: string;
  status: TaskStatus;
  priority: Priority;
  assigneeId?: number;
  reporterId?: number;
  estimateHours: number;
  actualHours: number;
  dueDate?: string;
  createdAt: string;
}

export interface Deliverable {
  id: number;
  projectId: number;
  taskId?: number;
  title: string;
  description?: string;
  deliverableType: string;
  currentVersionNumber: number;
  approvalStatus: ApprovalStatus;
  createdAt: string;
}

export interface DeliverableVersion {
  id: number;
  deliverableId: number;
  versionTag: string;
  filePath?: string;
  fileSizeBytes: number;
  fileChecksum?: string;
  releaseNotes?: string;
  uploadedByUserId?: number;
  uploadedAt: string;
}

export interface Approval {
  id: number;
  deliverableVersionId: number;
  clientUserId: number;
  decision: ApprovalDecision;
  feedbackNotes: string;
  decisionTimestamp: string;
}

export interface ReleaseChecklistItem {
  id: number;
  releaseId: number;
  checkCategory: string;
  description: string;
  isMandatory: boolean;
  isSatisfied: boolean;
  verifiedByUserId?: number;
  verificationNotes?: string;
}
