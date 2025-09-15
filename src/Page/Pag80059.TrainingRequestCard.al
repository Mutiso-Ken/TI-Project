#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80059 "Training Request Card."
{
    PageType = Card;
    SourceTable = "Training Requests";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application Code"; Rec."Application Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Training Need"; Rec."Training Need")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Employees Involved"; Rec."Employees Involved")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Business Linkage"; Rec."Business Linkage")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Job Relation"; Rec."Job Relation")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Hope to Learn"; Rec."Hope to Learn")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Details of Training"; Rec."Details of Training")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Other Details"; Rec."Other Details")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin


                        ApprovalEntry.Reset;
                        ApprovalEntry.SetRange("Document No.", Rec."Application Code");
                        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                        Page.Run(658, ApprovalEntry);
                    end;
                }
                action("Send A&pproval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        Text001: label 'This Batch is already pending approval';
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField("Employee Code");
                        Rec.TestField("Training Need");

                        Rec.TestField(Status, Rec.Status::New);

                        varrvariant := Rec;

                        if CustomApprovalsCodeunit.CheckApprovalsWorkflowEnabled(varrvariant) then
                            CustomApprovalsCodeunit.OnSendDocForApproval(varrvariant);
                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        //IF ApprovalMgt.CancelBatchAppr(Rec,TRUE,TRUE) THEN;
                        //varrvariant:=Rec;
                        //CustomApprovalsCodeunit.OnCancelDocApprovalRequest(varrvariant);
                        ApprovalEntry.Reset;
                        ApprovalEntry.SetRange("Document No.", Rec."Application Code");
                        if ApprovalEntry.FindSet then begin
                            repeat
                                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                                ApprovalEntry.Modify;
                            until ApprovalEntry.Next = 0;
                        end;
                        Rec.Status := Rec.Status::New;
                        Rec.Modify;
                    end;
                }
                action("Add to Calendar")
                {
                    ApplicationArea = Basic;
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.TestField(Status, Rec.Status::Approved);
                        if Confirm('Are you sure you want to Add the training to calendar') then begin
                            TrainingSchedule.Init;
                            TrainingSchedule.Year := Format(Date2dmy(Today, 3));
                            TrainingSchedule.Facilitator := Rec."Employees Involved";
                            // TrainingSchedule."Department/Organization":=
                            TrainingSchedule.Topic := Rec."Details of Training";
                            // TrainingSchedule."Total Cost"
                            // TrainingSchedule."Scheduled date":=
                            TrainingSchedule.Status := TrainingSchedule.Status::Pending;
                            TrainingSchedule."Updated By" := UserId;
                            TrainingSchedule."Updated On" := Today;
                            TrainingSchedule.Insert;
                            Message('Added successfully');
                        end;
                    end;
                }
            }
        }
    }

    var
        ApprovalEntry: Record "Approval Entry";
        varrvariant: Variant;
        CustomApprovalsCodeunit: Codeunit "Custom Approvals Codeunit";
        TrainingSchedule: Record "Training Schedule";
}

