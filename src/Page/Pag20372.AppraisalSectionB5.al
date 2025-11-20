

// page 20372 "Appraisal Section B5"
// {
//     ApplicationArea = All;
//     Caption = 'General Comments by supervisor on the above section:';
//     PageType = ListPart;
//     SourceTable = "Appraisal Lines Section B";
//     SourceTableView = where(Question = const("General Comments"));


//     layout
//     {
//         area(content)
//         {
//             repeater(Control2)
//             {
//                 field(Question; Rec.Question)
//                 {
//                     ApplicationArea = all;
//                     ValuesAllowed = "General Comments";
//                 }

//                 field("Comments by the supervisor2"; Rec."Comments by the supervisor")
//                 {
//                     Caption = 'Supervisor`s Feedback';
//                     ApplicationArea = Basic;
//                     MultiLine = true;
//                 }
//             }

//         }

//     }

// }