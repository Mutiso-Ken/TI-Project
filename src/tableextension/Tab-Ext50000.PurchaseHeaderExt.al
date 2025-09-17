tableextension 50000 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(9002; DocApprovalType; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Purchase,Requisition,Quote,Capex';
            OptionMembers = Purchase,Requisition,Quote,Capex;
        }
        field(9003; PR; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9004; Requisition; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9005; Service; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9006; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9007; "Doc Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,PurchReq,"Mission Proposal";
        }
        field(9008; Completed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9009; "Requisition No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where(PR = const(true));//, Status = const(Released));


            trigger OnValidate()
            begin
                //CHECK WHETHER HAS LINES AND DELETE
                if Confirm('If you change the requisition no. the current lines will be deleted. Do you want to continue?') then begin

                    PurchLine.Reset;
                    PurchLine.SetRange(PurchLine."Document No.", "No.");

                    if PurchLine.Find('-') then
                        PurchLine.DeleteAll;


                    //POPULATTE PURCHASE LINE WHEN USER SELECTS RFQ.
                    RFQ.Reset;
                    RFQ.SetRange("Document No.", "Requisition No");
                    if RFQ.Find('-') then begin
                        repeat
                            PurchLine2.Init;

                            LineNo := LineNo + 1000;
                            PurchLine2."Document Type" := "Document Type";
                            PurchLine2.Validate("Document Type");
                            PurchLine2."Document No." := "No.";
                            PurchLine2.Validate("Document No.");
                            PurchLine2."Line No." := LineNo;
                            PurchLine2.Type := RFQ.Type;
                            PurchLine2."No." := RFQ."No.";
                            PurchLine2.Validate("No.");
                            PurchLine2.Description := RFQ.Description;
                            PurchLine2."Description 2" := RFQ."Description 2";
                            PurchLine2.Quantity := RFQ.Quantity;
                            PurchLine2.Validate(Quantity);
                            PurchLine2."Unit of Measure Code" := RFQ."Unit of Measure Code";
                            PurchLine2.Validate("Unit of Measure Code");
                            PurchLine2."Direct Unit Cost" := RFQ."Direct Unit Cost";
                            PurchLine2.Validate("Direct Unit Cost");
                            PurchLine2."Location Code" := RFQ."Location Code";
                            //PurchLine2."RFQ No.":="Request for Quote No.";
                            //PurchLine2.VALIDATE("RFQ No.");
                            PurchLine2."Location Code" := "Location Code";
                            PurchLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            PurchLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                            PurchLine2.Insert(true);

                        until RFQ.Next = 0;
                    end;
                end;
            end;
        }
        field(9010; "Order No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9011; "Invoice No"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9012; "Strategic Focus Area"; Code[2048])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text".Code where(Type = const("Focus Area"));
        }
        field(9013; "Sub Pillar"; Code[2048])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text".Code where(Type = const("Sub Pillar"));
        }
        field(9014; "Project Title"; Code[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9015; Country; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region" where(Type = const(Country));
        }
        field(9016; County; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region" where(Type = const(County));
        }
        field(9017; "Date(s) of Activity"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(9018; "Mission Team"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9019; "Invited Members/Partners"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9020; MP; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9021; "Mission Proposal No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where(MP = const(true));//,Status = const(Released));

        }
        field(9022; IM; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9023; "Paying Account No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if BankAccount.Get("Paying Account No") then
                    "Paying Account Name" := BankAccount.Name;
            end;
        }
        field(9024; "Paying Account Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(9025; "Cheque No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9026; "Account No"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Customer.Get("Account No") then
                    "Account Name" := Customer.Name;
            end;
        }
        field(9027; "Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9028; "Imprest No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where(IM = const(true),
                                                             "Account No" = field("Account No"),
                                                             "User ID" = field("User ID"),
                                                             Surrendered = const(false));
        }
        field(9029; SR; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9030; Surrendered; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9031; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                DimensionValue.Reset;
                DimensionValue.SetRange(Code, "Shortcut Dimension 3 Code");
                if DimensionValue.FindFirst then begin
                    if DimensionValue.Blocked = true then
                        Error('Budget Line is blocked');
                end;

                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(9032; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(9033; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(9034; Background; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9035; "Contribution to focus"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9036; "Main Outcome"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(9037; "Budget Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90038; "Mission Total"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Purchase Line"."Total Ksh" where("Document Type" = field("Document Type"),
                                                                 "Document No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000778; "Imprest Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000779; "Imprest Holder"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees";
        }
        field(99000780; "Previous Imprest Accounted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99000781; "No of Days Outstanding"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000782; "Finance Action"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(99000783; InsertPortal; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //CHECK WHETHER HAS LINES AND DELETE
                //IF CONFIRM('If you change the imprest no. the current lines will be deleted. Do you want to continue?')  THEN BEGIN

                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document No.", "No.");

                if PurchLine.Find('-') then
                    PurchLine.DeleteAll;

                PurchaseHeader2.Reset;
                PurchaseHeader2.SetRange("No.", "Imprest No");
                if PurchaseHeader2.FindFirst then begin
                    "Mission Proposal No" := PurchaseHeader2."Mission Proposal No";
                    "Shortcut Dimension 1 Code" := PurchaseHeader2."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PurchaseHeader2."Shortcut Dimension 2 Code";
                    "Shortcut Dimension 3 Code" := PurchaseHeader2."Shortcut Dimension 3 Code";
                    "Shortcut Dimension 4 Code" := PurchaseHeader2."Shortcut Dimension 4 Code";
                    "Shortcut Dimension 5 Code" := PurchaseHeader2."Shortcut Dimension 5 Code";
                end;
                //POPULATTE PURCHASE LINE WHEN USER SELECTS IMP.
                RFQ.Reset;
                RFQ.SetRange("Document No.", "Imprest No");
                if RFQ.Find('-') then begin
                    repeat
                        PurchLine2.Init;

                        LineNo := LineNo + 1000;
                        PurchLine2."Document Type" := "Document Type";
                        PurchLine2.Validate("Document Type");
                        PurchLine2."Document No." := "No.";
                        PurchLine2.Validate("Document No.");
                        PurchLine2."Line No." := LineNo;
                        PurchLine2.Type := RFQ.Type;
                        PurchLine2."No." := RFQ."No.";
                        PurchLine2.Validate("No.");
                        PurchLine2.Description := RFQ.Description;
                        PurchLine2."Description 2" := RFQ."Description 2";
                        PurchLine2.Quantity := RFQ.Quantity;
                        PurchLine2.Validate(Quantity);
                        PurchLine2."Unit of Measure Code" := RFQ."Unit of Measure Code";
                        PurchLine2.Validate("Unit of Measure Code");
                        PurchLine2."Direct Unit Cost" := RFQ."Direct Unit Cost";
                        PurchLine2.Validate("Direct Unit Cost");
                        PurchLine2."Location Code" := RFQ."Location Code";
                        PurchLine2."Location Code" := "Location Code";
                        PurchLine2."Expense Category" := RFQ."Expense Category";
                        PurchLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                        PurchLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        //PurchLine2."Shortcut Dimension 3 Code":="Shortcut Dimension 3 Code";
                        PurchLine2.Insert(true);

                    until RFQ.Next = 0;
                end;
                //END;
            end;
        }
        field(99000784; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Employees"."No.";

            trigger OnValidate()
            begin
                if HREmployees.Get("Employee No") then begin
                    "Employee Name" := HREmployees."First Name" + ' ' + HREmployees."Middle Name";
                    "Timesheet Approver" := HREmployees."Supervisor User ID";
                end;
            end;
        }
        field(99000785; "Employee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99000786; Archived; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99000787; APP; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99000788; "Appraisal Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000789; PM; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99000790; "Review From"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(99000791; "Review To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(99000792; TM; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(99000793; "Date From"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(99000794; "Date To"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(99000795; "No of THours"; Decimal)
        {
            CalcFormula = sum("TE Time Sheet1".Hours where(Code = field("No.")));
            FieldClass = FlowField;
        }
        field(99000796; Narration; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(99000797; "Timesheet Approver"; Code[500])
        {
            DataClassification = ToBeClassified;
        }
    }




    var
        RFQ: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        LineNo: Integer;
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        PurchaseHeader2: Record "Purchase Header";
        HREmployees: Record "HR Employees";
        DimensionValue: Record "Dimension Value";
}
