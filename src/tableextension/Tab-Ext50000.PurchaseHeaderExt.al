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
        field(8089; "Approval Entries"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
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
                // if Confirm('If you change the requisition no. the current lines will be deleted. Do you want to continue?') then begin

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
                        PurchLine2."Description 3" := RFQ."Description 3";
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
                    // end;
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
                                                          "Dimension Value Type" = const(Standard),
                                                          Blocked = const(false),
                                                          "Fund Code" = field("Shortcut Dimension 1 Code"));

            trigger OnValidate()
            begin
                DimensionValue.Reset;
                DimensionValue.SetRange(Code, "Shortcut Dimension 3 Code");
                if DimensionValue.FindFirst then begin
                    if DimensionValue.Blocked = true then
                        Error('Budget Line is blocked');
                end;

                if "Shortcut Dimension 4 Code" <> '' then begin
                    DimensionValue.Reset;
                    DimensionValue.SetRange("Global Dimension No.", 4);
                    DimensionValue.SetRange(Code, "Shortcut Dimension 4 Code");
                    DimensionValue.SetRange("Budget Line", "Shortcut Dimension 3 Code");
                    if not DimensionValue.FindFirst() then
                        Validate("Shortcut Dimension 4 Code", '');
                end;

                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(9032; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          "Dimension Value Type" = const(Standard),
                                                          Blocked = const(false),
                                                          "Budget Line" = field("Shortcut Dimension 3 Code"));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
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
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
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
        field(90039; "Procurement Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Tender,RFQ,Direct Procurement,RFP"';
            OptionMembers = " ",Tender,RFQ,"Direct Procurement",RFP;
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
                    if HREmployees."Middle Name" <> '' then
                        "Employee Name" := HREmployees."First Name" + ' ' + HREmployees."Middle Name" + ' ' + HREmployees."Last Name"
                    else
                        "Employee Name" := HREmployees."First Name" + ' ' + HREmployees."Last Name";
                    "Account Name" := HREmployees."First Name" + ' ' + HREmployees."Middle Name";
                    "Timesheet Approver" := HREmployees."Supervisor User ID";
                    // Rec.Modify();
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
            //\ CalcFormula = sum("TE Time Sheet1".Hours where(co = field("No.")));
            // FieldClass = FlowField;
        }
        field(99000796; Narration; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(99000797; "Timesheet Approver"; Code[500])
        {
            DataClassification = ToBeClassified;
        }
        field(99000798; Description; Text[2048])
        {
            DataClassification = ToBeClassified;
        }

        field(90100; "Request For"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Self,Other';
            OptionMembers = Self,Other;
        }
        field(90101; Purpose; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(90102; "Bank Balance"; Decimal)
        {
            Editable = false;
        }
        field(90103; "Employee Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90104; "Petty Cash Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90105; "Claim Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90106; "Created On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90107; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90108; "Posted By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(90109; "Posted On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90110; "Surrender Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90111; "Surrender Booked"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90112; "Surrender No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90113; "Expected Date of Surrender"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90114; "EFT No"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(90115; "Budget Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90116; "Requesting Employee"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90117; "Requesting Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90118; "Transfered To Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90119; "Date of Transfer"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90120; "Purpose Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90121; "To Recover From Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90122; "Receipt No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90123; "Receipt Amount"; Decimal)
        {
            Editable = false;
        }
        field(90124; "Actual Imprest Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90125; "Date Approved"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90126; "Payroll Period"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90127; "Gross Allowance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90128; "Net Allowance(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90129; "Total Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90130; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        }
        field(90131; "CBS Member Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(90132; "Loan Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90133; "Repayment Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90134; Instalments; Decimal)
        {
            Editable = false;
        }
        field(90135; "Basic Pay"; Decimal)
        {
            Editable = false;
        }
        field(90136; "1/3 of Basic"; Decimal)
        {
            Editable = false;
        }
        field(90137; "Take Home"; Decimal)
        {
            Editable = false;
        }
        field(90138; "Amount Requested"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90139; "Months Paid"; DateFormula)
        {
            Editable = false;
        }
        field(90140; "Current Net Pay"; Decimal)
        {
            Editable = false;
        }
        field(90141; "Imprest Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Local,International"';
            OptionMembers = " ","Local",International;
        }
        field(90142; "Amount(LCY)"; Decimal)
        {
            Editable = false;
        }
        field(90143; "M-PESA Withdrawal Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90144; "Charge as a Single Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90145; "Picked for EFT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90146; "Taxable Amout"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90147; "Rejection Comments"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(90148; Supervisor; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90149; "Approval Status Min"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = min("Approval Entry".Status where("Document No." = field("No.")));
        }

        field(90150; "Created By"; Code[75])
        {
            DataClassification = ToBeClassified;
        }
        field(90151; Title; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(90152; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(90153; "Supplier Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category"."Category Code";
        }
        field(90154; "Requesting Person"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee,Delegate';
            OptionMembers = Employee,Delegate;
        }
        field(90155; "Process Initiated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90156; "Project Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Header"."No." where(Blocked = const(false));
        }

    }



    trigger OnBeforeInsert()
    begin
        // FORCE Invoice document type regardless of context
        // if "Document Type" = "Document Type"::Quote then
        //     "Document Type" := "Document Type"::Invoice;

    end;



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
