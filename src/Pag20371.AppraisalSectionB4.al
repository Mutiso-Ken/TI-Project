

// page 20371 "Appraisal Section B4"
// {
//     ApplicationArea = All;
//     Caption = 'What are some of the problems encountered and how were they handled?';
//     PageType = ListPart;
//     SourceTable = "Appraisal Lines Section B";
//     SourceTableView = where(Question = const("What are some of the problems encountered and how were they handled?"));


//     layout
//     {
//         area(content)
//         {
//             repeater(Control2)
//             {
//                 field(Question; Rec.Question)
//                 {
//                     ApplicationArea = all;
//                     ValuesAllowed = "What are some of the problems encountered and how were they handled?";
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