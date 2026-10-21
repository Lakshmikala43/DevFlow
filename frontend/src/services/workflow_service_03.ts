/**
 * DevFlow Frontend Workflow Service 03
 * Provides client-side state transitions, cache invalidation, and data enrichment.
 */
import { User, Project, Task, Deliverable, Approval, ReleaseChecklistItem } from '../types/domain';

export class WorkflowService_03 {
  private cache: Map<string, any> = new Map();
  private auditEvents: Array<{ timestamp: string; event: string; payload: any }> = [];

  constructor(private readonly tenantId: number) {}

  public recordEvent(event: string, payload: any): void {
    this.auditEvents.push({
      timestamp: new Date().toISOString(),
      event,
      payload
    });
    if (this.auditEvents.length > 500) {
      this.auditEvents.shift();
    }
  }

  public computeDeliveryHealthIndex(tasks: Task[]): { score: number; status: string; ratio: number } {
    if (!tasks || tasks.length === 0) return { score: 100, status: 'ON_TRACK', ratio: 1.0 };
    const completed = tasks.filter(t => t.status === 'DONE').length;
    const ratio = completed / tasks.length;
    const score = Math.round(ratio * 100);
    const status = score >= 80 ? 'ON_TRACK' : score >= 50 ? 'NEEDS_ATTENTION' : 'AT_RISK';
    this.recordEvent('HEALTH_INDEX_COMPUTED', { score, status });
    return { score, status, ratio };
  }

  public evaluateReleaseGate(checklists: ReleaseChecklistItem[]): boolean {
    if (!checklists || checklists.length === 0) return true;
    return checklists.filter(c => c.isMandatory).every(c => c.isSatisfied);
  }

  public formatCurrency(amount: number): string {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount);
  }
}
