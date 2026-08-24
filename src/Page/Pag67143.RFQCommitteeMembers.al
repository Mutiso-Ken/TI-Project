page 67143 "RFQ Committee Members"
{
    PageType = List;
    SourceTable = "RFQ Committee Members";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RFQ No."; Rec."RFQ No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Committee UserID"; Rec."Committee UserID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Committee Member Name"; Rec."Committee Member Name")
                {
                    ApplicationArea = All;
                }
                field("Email Sent"; Rec."Email Sent")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Notify Committee Members")
            {
                ApplicationArea = All;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RFQCommitteeMembers: Record "RFQ Committee Members";
                    HREmployee: Record "HR Employees";
                    PurchSetup: Record "Purchases & Payables Setup";
                    SMTPMail: Codeunit "Email Message";
                    SendEmail: Codeunit Email;
                    SendToList: List of [Text];
                    Subject: Text[200];
                    Body: Text[2000];
                    SentCount: Integer;
                begin
                    if not Confirm('Send notifications to the committee members for this RFQ?', false) then
                        exit;
                    PurchSetup.Get();
                    PurchSetup.TestField("Procurement Email");

                    RFQCommitteeMembers.SetRange("RFQ No.", Rec."RFQ No.");
                    if not RFQCommitteeMembers.FindSet() then
                        exit;
                    repeat
                        if HREmployee.Get(RFQCommitteeMembers."Employee No.") then begin
                            HREmployee.TestField("Company E-Mail");
                            Subject := 'Invitation for RFQ Committee Evaluation - ' + RFQCommitteeMembers."RFQ No.";
                            Body := 'Dear ' + RFQCommitteeMembers."Committee Member Name" + ',<br><br>' +
                                'You have been invited as a committee member to evaluate Quotation No. ' +
                                RFQCommitteeMembers."RFQ No." + '.<br>Kindly log in to the ERP system to complete this task.' +
                                '<br><br>This is a system generated email. Do not reply to it.';
                            Clear(SendToList);
                            SendToList.Add(HREmployee."Company E-Mail");
                            SMTPMail.Create(SendToList, Subject, Body, true);
                            SMTPMail.AddRecipient(Enum::"Email Recipient Type"::Cc, PurchSetup."Procurement Email");
                            if SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default) then
                                SentCount += 1;
                            RFQCommitteeMembers."Email Sent" := true;
                            RFQCommitteeMembers.Modify();
                        end;
                    until RFQCommitteeMembers.Next() = 0;
                    Message('Sent %1 notification(s) to committee members.', SentCount);
                end;
            }
        }
    }
}
