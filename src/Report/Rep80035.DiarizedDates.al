#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80035 "Diarized Dates"
{
    WordLayout = 'Layouts/DiarizedDates.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Diarized Dates"; "Diarized Dates")
        {

            trigger OnPreDataItem();
            begin

            end;

            trigger OnAfterGetRecord();
            begin
                if ("Diarized Dates"."1st Notification On" = Today) or ("Diarized Dates"."2nd Notification On" = Today)
                or ("Diarized Dates"."3rd Notification On" = Today) then begin
                    //send email
                    Notify.Reset;
                    Notify.SetRange(code, "Diarized Dates".Code);
                    if Notify.FindSet then begin
                        repeat

                            BodyText :=
                                  '<br><br>' +
                                  'Dear ' + Notify.Names +
                                  '<br><br>' +
                                  "Diarized Dates".Body +
                                  '<br>' +
                                  'Thanks & Regards' +
                                  '<br><br>' +
                                  '*****************************.' +
                                  '<br><br>' +
                                  '<TI KENYA ERP>' +
                                  '<br><br>';
                            SMTPMail.Create(Notify.Email, "Diarized Dates".Header, BodyText, true);
                            SMTPSetup.Send(SMTPMail);
                        until Notify.Next = 0;
                    end;
                end;
            end;

        }
    }
    requestpage
    {
        SaveValues = false;
        layout
        {
        }

    }
    var
        BodyText: Text;
        DateStyle: Text;
        ShowAllEntries: Boolean;
        ShowChangeFactBox: Boolean;
        ShowRecCommentsEnabled: Boolean;
        ShowCommentFactbox: Boolean;
        HRLeaveApplication: Record "HR Leave Application";
        ApprovalEntry6: Record "Approval Entry";
        More: Text;
        SMTPSetup: Codeunit Email;
        SMTPMail: Codeunit "Email Message";
        HREmployees: Record "HR Employees";
        Notify: Record Notify;

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin

    end;

}