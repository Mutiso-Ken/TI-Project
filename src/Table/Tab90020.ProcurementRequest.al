table 90020 "Procurement Request"
{
    fields
    {
        field(1; "No."; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(3; Title; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Requisiton No"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Current Budget"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name".Name;
        }
        field(6; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Supplier Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Supplier Category"."Category Code";

            trigger OnValidate();
            begin
                QuotationBidders.RESET;
                QuotationBidders.SETRANGE("Reference No", Rec."No.");
                IF QuotationBidders.FINDSET THEN BEGIN
                    QuotationBidders.DELETEALL;
                END;
            end;
        }
        field(8; "Tender Opening Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Tender Duration"; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF FORMAT("Tender Duration") <> '' THEN BEGIN
                    TESTFIELD("Tender Opening Date");
                    "Tender Closing Date" := CALCDATE("Tender Duration", "Tender Opening Date");
                END;
            end;
        }
        field(10; "Tender Closing Date"; Date)
        {
            Caption = 'Initial Closing Date';
            DataClassification = ToBeClassified;
        }
        field(11; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(13; "Requires Inspection"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Tender Security Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Technical Pass Mark"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Tender Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Advertised,Tender Opening,Evaluation,Mandatory Req Evaluation,Technical Req Evaluation,Financial Evaluation,Order Created,Contract Created,Terminated';
            OptionMembers = New,Advertised,"Tender Opening",Evaluation,"Mandatory Req Evaluation","Technical Req Evaluation","Financial Evaluation","Order Created","Contract Created",Terminated;
        }
        field(17; "Quotation Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Supplier Invitation,Quote Submission,Order Created';
            OptionMembers = New,"Supplier Invitation","Quote Submission","Order Created";
        }
        field(18; "Procurement Plan"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Created By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Procurement Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Tender,RFQ,Direct Procurement,RFP"';
            OptionMembers = " ",Tender,RFQ,"Direct Procurement",RFP;
        }
        field(21; "Vendor No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";


            trigger OnValidate();
            begin
                IF Vendor.GET("Vendor No") THEN BEGIN
                    if Vendor."Reg Status" <> Vendor."Reg Status"::Approved then
                        IF NOT CONFIRM('The selected vendor is not registered as an approved vendor on the portal. Do you wish to proceed anyway?') THEN
                            EXIT;
                    // ERROR('Vendor must be registered as an approved vendor on the portal to be selected!');
                    Vendor.TESTFIELD("PIN No.");
                    "Vendor Name" := Vendor.Name
                END ELSE BEGIN
                    "Vendor Name" := '';
                END;

            end;
        }
        field(22; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Procurement Request Lines"."Total Amount" WHERE("Procurement No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(23; "RFP Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Order Created';
            OptionMembers = New,"Order Created";
        }
        field(24; "Direct Procurement Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Order Created';
            OptionMembers = New,"Order Created";
        }
        field(25; "Generated Order No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Date Awarded"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Date Advertisement"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Date of Mandatory Evaluation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Date of Technical Evaluation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Date of Financial Evaluation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Contract No Generated"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Tender Max Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Technical Total Scores"; Decimal)
        {
            // CalcFormula = Sum("Technical Specifications"."Max Weigth" WHERE("Reference No." = FIELD("No.")));
            // FieldClass = FlowField;
        }
        field(34; "Financial Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Financial Score" = 0 THEN
                    EXIT;

                TESTFIELD("Tender Max Score");
                IF "Financial Score" > "Tender Max Score" THEN
                    ERROR('Pass mark cannot be higher than maximum score');

                "Technical Score" := "Tender Max Score" - "Financial Score";
            end;
        }
        field(35; "Return Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Return Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(37; "Extended Closing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(38; "Extension Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(39; "Tender Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Open National,Open International,Restricted Tender"';
            OptionMembers = " ","Open National","Open International","Restricted Tender";
        }
        field(40; "Technical Evaluation Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Financial Evaluation Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Supplier Notification"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(43; "Date of Advertisement"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Source of Funds"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Date of contract signing"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(46; "Technical Score"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Technical Score" = 0 THEN
                    EXIT;


                TESTFIELD("Tender Max Score");
                IF "Technical Score" > "Tender Max Score" THEN
                    ERROR('Technical score cannot be higher than maximum score');

                "Financial Score" := "Tender Max Score" - "Technical Score";
            end;
        }
        field(47; "Awarded Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Minimum No. of Suppliers"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Terminated By"; Code[70])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Reason For Termination"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51; "Date of termination"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Reason For Vendor Selection"; Text[250])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                IF "Procurement Method" = "Procurement Method"::RFQ THEN BEGIN
                    ProcurementRequestLines.RESET;
                    ProcurementRequestLines.SETRANGE("Procurement No", "No.");
                    IF ProcurementRequestLines.FINDFIRST THEN BEGIN
                        REPEAT
                            ProcurementRequestLines.TESTFIELD("Vendor To Award");
                        UNTIL ProcurementRequestLines.NEXT = 0;
                    END;
                END;
            end;
        }
        field(53; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(54; "Original Doc. Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Maintenance';
            OptionMembers = ,Maintenance;
        }
        field(55; "Expected Delivery Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(56; "RFQ Deadline Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(57; "RFQ Com. Analysis Initiated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(58; "RFQ Deadlne Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59; "Archives"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60; Advertised; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR('You cannot delete a created document');
    end;

    trigger OnInsert()
    var
        NoSeriesMgt: Codeunit "No. Series";
        ProcurementSetup: Record "Procurement Setup";
    begin
        if "No." = '' then begin
            ProcurementSetup.Get();
            case "Procurement Method" of
                "Procurement Method"::Tender:
                    begin
                        ProcurementSetup.TestField("Tender Nos");
                        "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Tender Nos", 0D, true);
                    end;
                "Procurement Method"::RFQ:
                    begin
                        ProcurementSetup.TestField("Quotation Nos");
                        "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Quotation Nos", 0D, true);
                    end;
                "Procurement Method"::RFP:
                    begin
                        ProcurementSetup.TestField("RFP Nos");
                        "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."RFP Nos", 0D, true);
                    end;
                else begin
                    ProcurementSetup.TestField("Direct Procurement Nos");
                    "No." := NoSeriesMgt.GetNextNo(ProcurementSetup."Direct Procurement Nos", 0D, true);
                end;
            end;
        end;
    end;

    var
        Vendor: Record "Vendor";
        QuotationBidders: Record "Quotation Bidders";
        ProcurementRequestLines: Record "Procurement Request Lines";
}

