-- 2-Role Academic Prototype, Section 7E (part 1): the return lifecycle
-- gains 'completed' (the refund-recorded end state). Wire states stay
-- pending/approved/rejected/completed — 'pending' is labeled "Under review"
-- in the UI (Requested = the submission act itself; user decision).
--
-- The value is USED by admin_complete_return in the next migration —
-- a just-added enum value cannot be referenced within the same transaction.

alter type public.return_status add value 'completed';
