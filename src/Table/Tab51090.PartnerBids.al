table 51090 "Partner Bids"
{
    DrillDownPageID = "Approved Bids ListPart";
    LookupPageID = "Approved Bids ListPart";

    fields
    {
        field(1; Partner; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            begin
                IF ObjCust.GET(Partner) THEN
                    Name := ObjCust.Name;
                Email := ObjCust."E-Mail";
                Phone := ObjCust."Phone No.";
            end;
        }
        field(2; Name; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Email; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Phone; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; RFA; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = RFA.No;
        }
        field(6; State; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Not Recommend for Funding,Recommend for Funding"';
            OptionMembers = " ","Not Recommend for Funding","Recommend for Funding";
        }
        field(7; "Awarded Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Awarded Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Approved Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Approved Amount(LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved,Cancelled';
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(12; "RFA Description"; Text[250])
        {
            CalcFormula = Lookup(RFA.Title WHERE(No = FIELD(RFA)));
            FieldClass = FlowField;
        }
        field(13; EntryNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(14; "Bid Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Total Amount Requested"; Decimal)
        {
            CalcFormula = Sum("Partner Implem. Activitie".Budget WHERE(RFA = FIELD(RFA),
                                                                        Partner = FIELD(Partner)));
            FieldClass = FlowField;
        }
        field(16; "Total Awarded Score"; Decimal)
        {
            CalcFormula = Sum("Partner Criteria Awards".Score WHERE(Partner = FIELD(Partner),
                                                                     RFA = FIELD(RFA)));
            FieldClass = FlowField;
        }
        field(17; "Bid Stage"; Option)
        {
            CalcFormula = Lookup(RFA.Stage WHERE(No = FIELD(RFA)));
            FieldClass = FlowField;
            OptionCaption = 'New,Bidding,Preliminary Assessment,Evaluation,Peer Review,Technical Review,Pre Award Survey,Sub Award';
            OptionMembers = New,Bidding,"Preliminary Assessment",Evaluation,"Peer Review","Technical Review","Pre Award Survey","Sub Award";
        }
    }

    keys
    {
        key(Key1; "Bid Code", Partner, RFA)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Bid Code", RFA, Name, "Awarded Amount", "Awarded Amount(LCY)")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "Bid Code" = '' THEN BEGIN
            ObjBids.RESET;
            IF ObjBids.FINDLAST THEN BEGIN
                "Bid Code" := INCSTR(ObjBids."Bid Code");
            END ELSE BEGIN
                "Bid Code" := 'BIDS0001';
            END;
        END;
    end;

    var
        ObjCust: Record "Customer";
        ObjBids: Record "Partner Bids";
}
