page 51088 "Selected RFA Partners"
{
    PageType = List;
    SourceTable = "Selected RFA Partners";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Partner; Rec.Partner)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Email; Rec.Email)
                {
                }
                field("Email Sent"; Rec."Email Sent")
                {
                    Editable = false;
                }
                field(Notified; Rec.Notified)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Notify Partners")
            {
                Image = Alerts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    Subject: Text[200];
                    Body: Text[1000];
                begin
                    IF CONFIRM('Are you sure you want to notify partners of this application?', FALSE) = TRUE THEN BEGIN
                        ObjPartners.RESET;
                        ObjPartners.SETRANGE(ObjPartners.RFA, Rec.RFA);
                        ObjPartners.SETRANGE(Notified, FALSE);
                        IF ObjPartners.FIND('-') THEN
                            REPEAT
                                Subject := '';
                                Body := '';
                                if ObjPartners.Email <> '' then begin
                                    Subject := CompanyName + ' Grants Management';
                                    Body := 'Greetings ' + Rec.Partner + ',<p> You have been invited to apply for ' +
                                    ObjRFA.Title + '. Please submit your applications via';
                                    Clear(SendToList);
                                    SendToList.Add(ObjPartners.Email);
                                    SMTPMail.Create(SendToList, Subject, Body, true);
                                    SMTPMail.AppendToBody('<p><i>This is an automated email. Do not reply</i><p>');
                                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
                                end;

                                ObjPartners.Notified := TRUE;
                                ObjPartners."Email Sent" := TRUE;
                                ObjPartners.MODIFY;
                            UNTIL ObjPartners.NEXT = 0;
                    END ELSE
                        ERROR('Process Aborted');
                end;
            }
        }
    }

    var
        ObjPartners: Record "Selected RFA Partners";
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;
        SendToList: List of [Text];
        ObjRFA: Record "RFA";
}
