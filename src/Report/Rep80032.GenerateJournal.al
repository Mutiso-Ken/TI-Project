#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80032 "Generate Journal"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Allocation Header"; "Allocation Header")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if "Posting Date" = 0D then Error('Posting date must have a value');
                if "Journal Batch" = '' then Error('Journal batch must have a value');
                if "Document No" = '' then Error('Document No must have a value');
                if "Balancing Account" = '' then Error('Balancing Account must have a value');

                if "Allocation Header".Blocked = true then CurrReport.Skip;

                AllocationLine.Reset;
                AllocationLine.SetRange("Allocation No", "Allocation Header"."Allocation No");
                if AllocationLine.FindSet then begin
                    repeat
                        GenJnlLine.Init;
                        GenJnlLine."Journal Template Name" := 'GENERAL';
                        GenJnlLine."Journal Batch Name" := "Journal Batch";
                        GenJnlLine2.Reset;
                        GenJnlLine2.SetRange("Journal Template Name", 'GENERAL');
                        GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch");
                        if GenJnlLine2.FindLast then
                            GenJnlLine."Line No." := GenJnlLine2."Line No." + 10000;
                        GenJnlLine."Source Code" := 'GENJNL';
                        GenJnlLine."Posting Date" := "Posting Date";
                        GenJnlLine."Document No." := "Document No";
                        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                        GenJnlLine."Account No." := AllocationLine."G/L Account";
                        GenJnlLine.Validate(GenJnlLine."Account No.");
                        GenJnlLine.Description := "Allocation Header"."Posting Description";
                        GenJnlLine.Amount := AllocationLine.Amount;
                        GenJnlLine.Validate(GenJnlLine.Amount);
                        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
                        GenJnlLine."Bal. Account No." := "Balancing Account";
                        GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                        GenJnlLine."Shortcut Dimension 1 Code" := AllocationLine."Shortcut Dimension 1 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                        GenJnlLine."Shortcut Dimension 2 Code" := AllocationLine."Shortcut Dimension 2 Code";
                        GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                        if GenJnlLine.Amount <> 0 then
                            GenJnlLine.Insert;
                    until AllocationLine.Next = 0;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Message('Journal generated successfully');
            end;

            trigger OnPreDataItem()
            begin
                GenJnlLine2.Reset;
                GenJnlLine2.SetRange("Journal Template Name", 'GENERAL');
                GenJnlLine2.SetRange("Journal Batch Name", "Journal Batch");
                if GenJnlLine2.FindSet then
                    GenJnlLine2.DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Document No"; "Document No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No';
                    Visible = true;
                }
                field("Journal Batch"; "Journal Batch")
                {
                    ApplicationArea = Basic;
                    TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = const('GENERAL'));
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Balancing Account No"; "Balancing Account")
                {
                    ApplicationArea = Basic;
                    TableRelation = "G/L Account"."No.";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        "Document No": Code[10];
        "Journal Batch": Code[10];
        "Posting Date": Date;
        "Balancing Account": Code[10];
        AllocationLine: Record "Allocation LineII";
        Lineno: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
}

