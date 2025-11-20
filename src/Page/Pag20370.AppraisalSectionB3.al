

// page 20370 "Appraisal Section B3"
// {
//     ApplicationArea = All;
//     Caption = 'What didn’t you do well?';
//     PageType = ListPart;
//     SourceTable = "Appraisal Lines Section B";
//     SourceTableView = where(Question = const("What didn’t you do well?"));


//     layout
//     {
//         area(content)
//         {
//             repeater(Control2)
//             {
//                 field(Question; Rec.Question)
//                 {
//                     ApplicationArea = all;
//                     ValuesAllowed = "What didn’t you do well?";
//                 }
//                 field("Self-appraisal (Comments)2"; Rec."Self-appraisal (Comments)")
//                 {
//                     Caption = 'Self-appraisal (Comments)';
//                     ApplicationArea = Basic;
//                 }
//                 field("Comments by the supervisor2"; Rec."Comments by the supervisor")
//                 {
//                     Caption = 'Supervisor`s Feedback';
//                     ApplicationArea = Basic;
//                 }
//             }

//         }

//     }

// }