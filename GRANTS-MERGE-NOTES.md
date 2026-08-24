# Grants Management merge — status notes

Ported from RCK-BC-260's "Grant Management" Super Admin Role Centre section into TI-Project,
per an explicit decision to bring everything across as a **non-compiling draft** rather than
scope down to only the self-contained pieces. Nothing in RCK-BC-260 was modified — only read
from and copied.

**This will not compile as-is.** Treat this as a staged draft to close out gap-by-gap, not a
finished feature. Do this in a sandbox/dev copy of TI-Project, never against production, until
every TODO below is resolved and the whole thing has been test-compiled.

## What was added (initial pass — see later sections for what's been added/resolved since)

| Type | Count | Location |
|---|---|---|
| New tables | 15 | `src/Table/Tab{51081,51082,51083,51087,51089,51090,51091,51092,51093,51094,51102,90200,90201,90203,90204}*.al` |
| New pages | 16 | `src/Page/Pag{51042,51043,51044,51062,51066,51067,51072,51078,51082,90200,90201,90203,90204,90205,90207,90209}*.al` |
| New reports | 8 | `src/Report/Rep{50295,50296,50297,50298,50299,50300,50302,90200}*.al` + matching `.rdlc` in `Layouts/` |
| New tableextensions | 2 | `Tab-Ext50060.CustomerExtGrants.al`, `Tab-Ext50061.GLEntryExtGrants.al` |
| Edited (existing TI objects) | 2 | `Tab-Ext50049.DimensionValueExt.al` (+9 fields, numbers 70020-70029), `Tab-Ext50003.PurchaseLine3.al` (+9 fields, numbers 80001-80011) — both additive only, nothing renumbered or removed |
| Edited (Role Center) | 1 | `Pag20390.AdminRoleCenter.al` — new "Grant Management" group added to `area(sections)` |

All object IDs reused RCK's originals; a full sweep of TI's existing objects confirmed none of
them collide. The two new tableextensions got fresh IDs (50060, 50061) since TI had no existing
extension on Customer or G/L Entry to append to.

## Known gaps — grep for `TODO(grants-merge)` to find every instance inline

1. **RESOLVED — `Tab51081`/`Tab51082` (Grants Request Header/Lines — the "Advance Requests"
   workflow) are deliberately NOT wired into the live app.** Investigated TI's existing
   `Pag80072.ImprestRequestCard.al`: it posts imprests by building a `Gen. Journal Line` from
   `Purchase Header`/`Purchase Line` and routing it through the standard General Journal — no
   separate posting engine exists or is needed. Combined with the grant-tagging fields already
   added to `Purchase Line` in this merge, TI's native Purchase-Header imprest flow already covers
   grant-funded disbursements end to end. Porting RCK's `Grants Request Card` would have required
   ~1,400 more lines (`Imprest Management` codeunit, `Grant Administration`, `DMS Managementx`, a
   subform page, a report) purely to duplicate what already works. Decision: leave `Tab51081`/
   `Tab51082` as dormant, unwired tables (harmless — nothing references them for real use), and use
   `Pag80072.ImprestRequestCard.al` / `Pag80075.ImprestSurrender.al` for actual grant imprest work.
   `Pag51062`/`Pag51067` (Grants Open/Released Requests) had their dangling `CardPageID` reference
   removed accordingly. If `Tab51081`/`Tab51082` end up unused entirely, they're candidates for
   deletion in a later cleanup pass — left in for now since removing tables is a decision worth its
   own pass, not a side effect of this one.

2. **RESOLVED — `Tab51083` (Grant Funding Application)** — ported both `Funding Opportunity`
   (51084) and `Grant Types New` (51085, a small lookup table `Funding Opportunity` itself needs).
   Also added `"Grantor Nos"` to the Jobs Setup extension (`Tab-Ext50068`) for `Funding
   Opportunity`'s No. Series. This was the last real (non-dormant-module) gap.

3. **RESOLVED — `Tab51090` (Partner Bids)** FlowFields now resolve: `Partner Implem. Activitie`
   and `Partner Criteria Awards` were both ported (needed anyway for the Card pages in gap 5).

4. **RESOLVED — legacy codeunit name `NoSeriesManagement`** confirmed to resolve fine; it's used
   in 20+ pre-existing TI files.

5. **RESOLVED — Card/lookup pages.** All ported except one deliberate omission: `Proposals Card`,
   `Sub Award Card`, `Partner Bids Card`, `Partner Evaluation Card`, `Approved Bids ListPart`,
   `Concept Objectives`/`Concept Note Outcomes` (+ their tables `Concept Strategic Objective`/
   `Concept Outcomes`), and every list-part they needed (`RFA Instructions`/`Activities`/
   `Outcomes`/`Criteria`, `Selected RFA Partners`, `Partner Scoring`, `RFA Recommendation`) are all
   in. `Grants Request Card` was deliberately NOT ported — see gap 1, resolved by using TI's native
   imprest flow instead.

6. **`Pag90201` (Grant Card)** — nearly resolved: its `part("Grant Lines"; "Grant Lines")` subform
   needed page 90202 "Grant Lines" (distinct from "Grant Lines Lookup", Pag90204 — same base name,
   different page) and its Import action needed `XMLport 95004 "Import Grants"`; both ported. The
   "Transfer to Budget" action's `Page 90206` turned out to be "Grant Consolidation" — a small,
   fully self-contained card (only touches Grant Header/Lines/Detail Lines + standard `G/L Budget
   Entry`) backed by `Codeunit 50116 "Grant Administration"`; both now ported too (also closes the
   `GetGrantBudgetBalance` reference from the dormant `Tab51081` module, though that module stays
   unwired regardless). Still open: `REPORT.RUNMODAL(50293, ...)` on the "Expenditure" action is
   unidentified/not ported, and var `Page "Copy Grant Lines"` is declared but unused in the ported
   actions — its type still needs to resolve for the page to compile.

7. **`Pag51044` (Concept Note Card)** uses RCK's own `Codeunit "Custom Approvals Mgmt."` — not
   ported. TI has its own approval patterns elsewhere; rewire to those rather than porting RCK's
   codeunit wholesale. Still open.

8. **RESOLVED — `User Setup."Grant Admin"` / `General Ledger Setup` grant fields** — added via
   the table-extension pass below.

## Deliberately out of scope

- `src/Sub-Grant/` in RCK (Organization Data, Organization Proposal Apps, Sub-Grant Portal
  codeunit) — looked like a separate external partner-facing portal, not referenced from the
  Grant Management role-center section. Flag for a follow-up scoping decision.
- Codeunits that touch grants but aren't grant-specific: `Cod50017 ImprestManagement`,
  `Cod50047 PortalEntry`, `Cod50064 PortalReports`, `Cod50116 GrantAdministration`,
  `Cod50117 DataMigrationm`, `Cod50237 UpdateGrantsOnreceipts`. Pulling whole objects would drag
  in unrelated logic — if/when needed, extract the grant-specific procedures individually.

## Harmonization pass — pre-existing TI scaffolding activated

A sweep of TI's *pre-existing* (git-tracked, predating this merge) files for Grant references
turned up one real hit: `src/Table/Tab28.ProcurementRequestLines.al` already had fields
`Grant No.` / `Objective Code` / `Output Code` / `Outcome Code` / `Activity Code` / `Partner Code`
(numbers 50001-50005, 50008) with their `TableRelation`s and the `Partner Code` lookup trigger
**commented out**, referencing `"Grant Header"`/`"Grant Lines"`/`"Grant Detail Lines"` by name —
i.e. someone had already planned for this integration and stubbed it out pending those tables
existing. Now that they do (this merge), those relations/trigger were un-commented and reactivated
as originally written — no redesign needed, the original author already wrote it correctly against
this table's own field names (`No`, `Type`).

Left alone: `"Procurement Plan"` (field 70020) on the same table has an identical commented-out
`TableRelation = "The Procurement Plan"."No."` — but `"The Procurement Plan"` is a *different*,
not-yet-ported RCK table (unrelated to Grants), so this one stays dormant. `Donor Code`/`Donor Name`
(70008/70009) are plain fields with no relation stub — left as-is, no scaffolding to activate there.

No other pre-existing TI file (checked via full-repo sweep, case-insensitive, several spelling
variants) references Grant Header/Grant Lines/Grant Detail Lines/Grant Admin — this was the only
dormant hook.

## Table-extension pass — missing fields on standard tables closed out

Scanned every ported Grants file for references to fields on standard/setup tables that TI didn't
already carry, and added 7 new minimal tableextensions (each carrying only the fields actually
referenced, matching RCK's original types/options):

| Extension | Table | Fields added |
|---|---|---|
| `Tab-Ext50062` | User Setup | `Grant Admin` |
| `Tab-Ext50063` | General Ledger Setup | `Grant Nos.`, `Current Budget`, `Current Budget Start/End Date` |
| `Tab-Ext50064` | Sales & Receivables Setup | `Max No of Imprests`/`Disbursements`, `Grants Request/Surrender Nos` |
| `Tab-Ext50065` | Payment Method | `M-PESA` |
| `Tab-Ext50066` | Bank Account | `M-Pesa Cashbook` |
| `Tab-Ext50067` | Employee | `Full Name`, `Grade`, `Nature Of Employment`, `CBS Member Id` (TI's own modules mostly use a separate custom `HR Employees` table instead — another sign Grants Request Lines wasn't built against TI's actual HR data model) |
| `Tab-Ext50068` | Jobs Setup | `Proposal Nos`, `Concept Nos`, `System Contract Nos`, `Objective Nos`, `Outcome Nos` |
| `Tab-Ext50069` | Purchases & Payables Setup | `Budget Balance 25%`, `Budget Balance 10%` (referenced by the dormant `Tab51082` budget-depletion logic) — also exposed on the existing `Pag-Ext172185.PayablesSetup.al` page extension rather than creating a new one |
| `Tab-Ext50070` | G/L Budget Entry | `Source Code` — the one custom field `Cod50116.GrantAdministration.al`'s `ConsolidateGrant` needs; standard BC fields on this table (Entry No., Budget Name, G/L Account No., Amount, etc.) needed no extension |

Also confirmed: the legacy unquoted `Codeunit NoSeriesManagement` name (gap #4 above) resolves fine
— it's used in 20+ pre-existing TI files, so no change needed there.

**RESOLVED — the ~17 whole missing tables/codeunits/pages `Grants Request Header`/`Lines` needed**
(`Imprest Purpose`, `Receipt Header`, `Staff Loans`, `Payroll Periods`, `Payroll Period Transaction`,
`Payroll Salary Card`, `Additional Charges`, `M-PESA Charges`, `M-PESA Withdrawal Charges`,
`Cheque Ledger Entries`, `Payroll Vital Setup`, `Payment Types`, `Allowance Tax Set Up`,
`Per Diem Rates`, codeunits `IanSoftFactory`/`Payroll Processing`, pages `Per Diem Scales LookUp`/
`Requisition Rates` — new IDs 51150-51163/51150-51151/51150-51151 respectively). Since this module
is permanently dormant (gap 1), these were created as **minimal stubs** — only the specific
fields/procedure signatures actually referenced, not RCK's full real implementations (some of
which, like the real `Receipt Header`, run 555 lines for a table this module only touches on 4
fields). Bodies do nothing / return 0; nothing in the live app ever calls them. `Confirm Management`
turned out to already be a standard BC codeunit (confirmed via 1 pre-existing TI reference) — no
stub needed there.
- `Grant Funding Application`: `Funding Opportunity`, `Grant Types New` — still open (gap 2).

Everything else — Grant Header/Lines/Detail Lines, SpeedKey Setup, Concept Notes, the RFA family,
Partner Bids, the pre-award Card pages, and the Procurement harmonization pages — should now be
free of "field/table doesn't exist" errors.

## Current state

**Resolved**: gaps 1, 3, 4, 5, 8, plus the harmonization and table-extension passes above.
**Still open**: gap 2 (`Grant Funding Application`'s two missing tables), gap 6 (`Grant Card`'s
three small unresolved references), gap 7 (`Concept Note Card`'s approvals codeunit).

## Harmonization pass — attachments factbox

Swapped the standard BC "Document Attachments" factbox (backed by system table `Document
Attachment`, keyed by `Table ID` + `No.`) for TI's own native pattern — table `Portal Documents`
(171228) + page `Document Uploads` (95013), keyed by `Document Number` — across all 4 Grant
Management cards that had it: `Concept Note Card`, `Proposals Card`, `Sub Award Card`,
`Partner Bids Card`. This is the same attachment mechanism TI already uses elsewhere (e.g.
`Pag80072.ImprestRequestCard.al`'s "Attachments" action), so Grant records now show up alongside
everything else uploaded through that system rather than in a separate, standard-BC-only store.

## Harmonization pass — Purchase Header / "Request Header" parity

RCK has a second, near-identical table to `Grants Request Header`: `"Request Header"` (64020, 1202
lines), the shared base for its own Imprest/Surrender/Claim/Petty Cash/Staff_Board Allowance/
Re-imbursement/Salary Advance modules. TI never had this table — it standardized on `Purchase
Header` (with `IM`/`MP`/`SR`/`APP`/`PM`/`TM` flags distinguishing request kinds) as the equivalent
for its own Task Order/Mission Proposal/Imprest Request/Imprest Surrender/Performance Appraisal/
Payment Memo cards. Per instruction, rather than porting "Request Header" as a new, competing
table, compared its ~74 fields against TI's existing `Purchase Header` and added the ~49 that were
genuinely missing — directly into TI's existing `Tab-Ext50000.PurchaseHeaderExt.al` (field numbers
90100-90149; a separate tableextension was tried first, then merged in on request rather than kept
as a second object on the same table).

**Deliberately not added**: RCK's `"Request Type"` option field (Imprest/Surrender/Claim/Petty
Cash/Staff_Board Allowance/Re-imbursement/Salary Advance) — TI already differentiates request kinds
via its boolean flags; a second, option-based classification would conflict rather than fill a gap.
`"Pay Mode"`/`"Exchange Rate"`/`"Exchange Rate Factor"` also skipped — standard Purchase Header
already covers these via `"Payment Method Code"`/`"Currency Factor"`. All 49 added fields are plain
data fields — RCK's business logic for them (M-PESA charge automation, payroll transfer, etc.)
lived in workflow code that wasn't ported; wire up real logic if/when these fields get used for
real.

**Cards updated** to surface the newly-relevant fields: `Pag80072.ImprestRequestCard.al` (Request
For, Purpose, Account Type, Imprest Type, Bank Balance, Amount(LCY), Petty Cash/Claim Amount,
Budget Code, Date Approved, Posted/By/On, M-PESA Withdrawal Fee, Rejection Comments) and
`Pag80076.ImprestSurrenderCard.al` (Surrender Amount/No/Booked, Expected Date of Surrender, Receipt
No/Amount, Actual Imprest Amount, Posted/By/On, Rejection Comments). TI has no Salary Advance/
Allowance/Petty Cash cards at all, so the payroll-advance-specific fields (Basic Pay, Take Home,
Loan Type, Repayment Period, Instalments, Current Net Pay, Months Paid, Gross/Net Allowance, Total
Tax, Taxable Amout, CBS Member Id) are on the table for parity but not surfaced anywhere yet —
add them to a card if/when those workflows get built.

## Fixed — stray "Request Header" references in Tab51082

`Tab51082.GrantsRequestLines.al` had 3 FlowFields (`Posted`, `Document Type`, `Status`) whose
CalcFormulas referenced a bare `"Request Header"` — RCK's other base table (see the harmonization
pass above), never ported, and not the module's own `"Grants Request Header"` parent either. This
was a copy-paste artifact in RCK's original source. Per instruction, repointed to `"Purchase
Header"` instead:
- `Posted` → clean match, Purchase Header has the same field now.
- `Status` → swapped as requested, but flagged in a comment: Purchase Header's real Status values
  (Open/Pending Approval/Pending Prepayment/Released) don't semantically align with this field's
  (New/Pending Approval/Approved/Rejected) past position 1 — a Released purchase header would show
  as "Rejected" here. Harmless since the module is dormant, but noted for if that ever changes.
- `Document Type` → no Purchase Header equivalent exists (its real Document Type is Quote/Order/
  Invoice/etc.; TI deliberately didn't port RCK's "Request Type" concept — see the pass above).
  Left as a plain field instead of forcing a lookup at an unrelated field.

## Harmonization pass — Purchase Line / "Request Lines" parity

Sibling to the Purchase Header pass above: RCK's `"Request Header"` has a matching line-level
table, `"Request Lines"` (64021) — near-identical in shape to `Grants Request Lines`
(`Tab51082`, right down to sharing the same custom field numbers 50000-50012). Compared its ~44
fields against TI's `Purchase Line` (already extended with the Grant-tagging fields from the
original merge) and appended the ~34 genuinely missing ones directly into the existing
`Tab-Ext50003.PurchaseLine3.al` (field numbers 90100-90142).

**Deliberately not added**: RCK's line-level `"Document Type"` (Imprest/Surrender/Claim/Petty
Cash/Staff_Board Allowance/Re-imbursement/Salary Advance) — this one doesn't just lack a clean
target, it **collides by name** with Purchase Line's own standard `"Document Type"` field
(Quote/Order/Invoice/etc.), so it couldn't be added under that name even if TI carried the concept
(which, per the header-level decision, it deliberately doesn't).

Also fixed the same `"Request Header"`-copy-paste bug found in `Tab51082` (`Posted`/`Status`/
`Posting Date` FlowFields) — repointed to `"Purchase Header"`, filtered on `"Document No."`
(Purchase Line's real header-link field; RCK's original used the nonexistent `"Request No"` here
too). `"Posting Date"` maps cleanly; `"Status"` carries the same option-value mismatch caveat as
the header-level version. Named these `"Line Posted"`/`"Line Status"`/`"Line Posting Date"`/
`"Line Employee No"`/`"Line Employee Name"`/`"Line CBS Member Id"`/`"Line Budget Amount"` to keep
them visually distinct from their header-level counterparts, even though same-name-on-different-
tables would have compiled fine — purely a readability choice.

Also fixed the actual local-variable bug this all started from: `Tab51082`'s
`IanGetAmountFromPreviousLines` procedure declared `Record "Request Lines"` and filtered on fields
that don't exist on Purchase Line (`"Request No"`, `"Account No"`, `"Line No"` without the period).
Repointed to `Record "Purchase Line"` with the real field names (`"Document No."`, `"No."`,
`"Line No."`) — `"Amount (LCY)"` now resolves cleanly since it was added in this same pass.

## Harmonization pass — removed stub `Tab51153` "Payroll Periods" in favor of TI's real `Payroll Calender_AU`

TI already has a real, live payroll-periods table — `Tab80005 "Payroll Calender_AU"` — so the
minimal stub created earlier in this merge (`Tab51153 "Payroll Periods"`, part of the ~17-table stub
batch listed above) was redundant. Per instruction, deleted `Tab51153` and repointed its two real
referencers in the dormant `Tab51081.GrantsRequestHeader.al` to the existing table instead (no
changes made to `Tab80005` itself):
- `"Payroll Period"` field's `TableRelation` → `"Payroll Calender_AU"."Date Opened"` (its clustered
  primary key, the closest analog to the stub's `"Start Date"` — `Payroll Calender_AU` has no
  `"Start Date"` field of its own).
- `PayrollPeriods` local variable → `Record "Payroll Calender_AU"` (was declared, never actually
  used in the file, same as before).

The two `action("Payroll Periods")` entries on `Pag20366.MainRoleCenter.al`/
`Pag20390.AdminRoleCenter.al` were left untouched — they're just an action name/caption; their
`RunObject` already pointed at `Page "Payroll Calender_AU"` before this pass.

## Next steps

1. Resolve gaps 2, 6, 7 or strip the code paths that need them — all small/bounded now.
2. Full compile in a sandbox/dev copy of TI-Project; work through whatever the compiler still flags.
3. `Tab51081`/`Tab51082` (Grants Request Header/Lines) are dormant and unwired — candidates for
   deletion in a later cleanup if nothing ends up using them.
