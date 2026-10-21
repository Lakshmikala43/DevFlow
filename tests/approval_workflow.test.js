import test from 'node:test';
import assert from 'node:assert/strict';

test('DevFlow Approval Decision Engine', async (t) => {
  await t.test('approves deliverable when client accepts without conditions', () => {
    const decision = {
      deliverableId: 101,
      decision: 'APPROVED',
      feedback: 'All acceptance criteria validated by stakeholder.',
      timestamp: new Date().toISOString()
    };
    assert.equal(decision.decision, 'APPROVED');
    assert.ok(decision.feedback.length > 10);
  });

  await t.test('rejects revision requests that omit required explanatory comments', () => {
    function processDecision(decision, feedback) {
      if (decision === 'REVISION_REQUESTED' && (!feedback || feedback.trim().length === 0)) {
        throw new Error('Revision requests strictly require detailed feedback comments.');
      }
      return { status: 'REVISION_REQUESTED', feedback };
    }

    assert.throws(() => processDecision('REVISION_REQUESTED', ''), /require detailed feedback/);
    assert.doesNotThrow(() => processDecision('REVISION_REQUESTED', 'Please update the invoice logo'));
  });

  await t.test('calculates release gate readiness threshold correctly', () => {
    function calculateReadiness(totalTasks, doneTasks, blockerDefects) {
      if (blockerDefects > 0) return false;
      if (totalTasks === 0) return true;
      return (doneTasks / totalTasks) >= 0.90;
    }

    assert.equal(calculateReadiness(100, 95, 0), true);
    assert.equal(calculateReadiness(100, 85, 0), false);
    assert.equal(calculateReadiness(100, 95, 1), false);
  });
});
