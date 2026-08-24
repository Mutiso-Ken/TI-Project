tableextension 50003 "Purchase Line3" extends "Purchase Line"
{
    fields
    {
        field(172000; "Description 3"; Text[1000])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(7012; "Description 4"; Text[1000])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(7013; "Description 5"; Text[1000])
        {
            Caption = 'Description 5';
            DataClassification = ToBeClassified;
        }
        field(7014; "Description 6"; Text[2048])
        {
            Caption = 'Description 6';
            DataClassification = ToBeClassified;
        }

        field(99000760; "ShortcutDimCode[3]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000761; "ShortcutDimCode[4]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000762; "ShortcutDimCode[5]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000763; "ShortcutDimCode[6]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000764; "ShortcutDimCode[7]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000765; "ShortcutDimCode[8]"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(99000766; "Amount Spent"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                "Cash Refund" := "Line Amount" - "Amount Spent";
                Rec.Modify();
            end;
        }
        field(99000767; "Cash Refund"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000768; "Cash Refund  Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(99000769; "Expense Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text" where(Type = const("GL Category"));

            trigger OnValidate()
            begin
                exp := "Expense Category";
                Type := Type::"G/L Account";
                if StandardText.Get("Expense Category") then
                    Validate("No.", StandardText."GL Account");

                "Expense Category" := exp;
            end;
        }
        field(99000770; "Line Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Objectives,"Team Roles",Activity,"Budget Info","Budget Notes",Performance,Sections,PersonalQualities,Reflections,CapacityNeeds,ActionPoints;
        }
        field(99000771; "No of days"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000772; "No of pax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000773; Ksh; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Ksh" := "No of days" * "No of pax" * Ksh;
            end;
        }
        field(99000774; "other currency"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Total Other Currency" := "No of days" * "No of pax" * "other currency";
            end;
        }
        field(99000775; "Total Ksh"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000776; "Total Other Currency"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000777; "Mission Expense Category"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Standard Text" where(Type = const("GL Category"));
        }
        field(99000778; keyResultAreas; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Performance start';
        }
        field(99000779; keyActivities; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000780; performanceMeasures; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000781; commentsOnAchievedResults; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(99000782; target; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000783; actualAchieved; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000784; percentageOfTarget; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000785; rating; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000786; weightingRating; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000787; weighting; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(99000788; appraisalType; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Sections start';
            OptionCaption = 'Technical Capacity,Organisation and planning skills,Efficiency and Effectiveness,Communication,Leadership';
            OptionMembers = "Technical Capacity","Organisation and planning skills","Efficiency and Effectiveness",Communication,Leadership;
        }
        field(99000789; appraisalDescription; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(99000790; staffRating; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000791; supervisorRating; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000792; personalDescription; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Personal Qualities start';
        }
        field(99000793; score; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(99000794; comments; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000795; reflectionDescription; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Start refelctions';
        }
        field(99000796; selfAppraisal; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000797; supervisorsFeedback; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000798; capacity; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Start capacity needs';
        }
        field(99000799; completionDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(99000800; capacityNeedsDescription; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000801; remedialMeasures; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000802; planning; Text[400])
        {
            DataClassification = ToBeClassified;
            Description = 'Action points';
        }
        field(99000803; personResponsible; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000804; agreedActionPoints; Text[400])
        {
            DataClassification = ToBeClassified;
        }
        field(99000805; timelines; Text[400])
        {
            DataClassification = ToBeClassified;
        }

        field(80001; "Donor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate();
            var
                Customer: Record Customer;
            begin
                IF Customer.GET("Donor No.") THEN BEGIN
                    "Donor Name" := Customer.Name;
                END;
            end;
        }
        field(80002; "Grant No."; Code[20])
        {
            Caption = 'Grant No.';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Header"."No." WHERE(Blocked = const(false));
        }
        field(80003; "Objective Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Objective),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(80004; "Output Code"; Code[20])
        {
            Caption = 'Output Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Output),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(80005; "Outcome Code"; Code[20])
        {
            Caption = 'Outcome Code';
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Outcome),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(80006; "Activity Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Grant Lines".Code WHERE("Line Type" = CONST(Activity),
                                                      "Grant No" = FIELD("Grant No."));
        }
        field(80007; "Donor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80008; "Partner Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup();
            var
                GrantDetailLines: Record "Grant Detail Lines";
            begin
                GrantDetailLines.RESET;
                GrantDetailLines.SETRANGE("Grant Code", "Grant No.");
                GrantDetailLines.SETRANGE(Code, "Activity Code");
                IF PAGE.RUNMODAL(0, GrantDetailLines) = ACTION::LookupOK THEN BEGIN
                    "Partner Code" := GrantDetailLines."External Partner Code";
                END;
            end;
        }
        field(80009; "Grants Narration"; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(800010; "Grants Procurement Plan"; code[500])
        {
            DataClassification = ToBeClassified;
        }
        field(800011; "Grant Budget Amount"; Decimal)
        {
        }

        field(90100; "Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90101; Surrender; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90102; "Budget Code"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90103; "Available Amount"; Decimal)
        {
            Editable = false;
        }
        field(90104; "Budgeted Amount"; Decimal)
        {
            Editable = false;
        }
        field(90105; "Commited Amount"; Decimal)
        {
            Editable = false;
        }
        field(90106; "Total Expenditure"; Decimal)
        {
            Editable = false;
        }
        field(90107; Unbudgeted; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90108; "From Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90109; "To Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90110; "Imprest Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90111; "From Imprest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(90113; "Tax Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90114; "Tax Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90115; "Net Allowance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90116; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90117; "Line Employee No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90118; "Line Employee Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90119; "PD Transaction Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90120; Taxable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90121; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90122; "Payroll Scale"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90123; "Tax Relief"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(90125; "Daily Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90126; "Relief Days"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(90127; "Daily Tax Relief"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90128; "CBS Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90129; "Line CBS Member Id"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(90130; "Board Member"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = '" ,Contract,Permanent,Board"';
            OptionMembers = " ",Contract,Permanent,Board;
        }
        field(90131; "Allow Edit"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90132; "Balance Less Entry"; Decimal)
        {
            Editable = false;
        }
        field(90133; "Budget Depletion"; Option)
        {
            Editable = false;
            OptionCaption = '" ,75,90,100"';
            OptionMembers = " ","75","90","100";
        }
        field(90134; "Balance Before Entry"; Decimal)
        {
            Editable = false;
        }
        field(90135; "Budget G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(90136; Additional; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90137; "M-pesa Withdrawal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90138; "M-pesa Transaction"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90139; "Line Posted"; Boolean)
        {
            CalcFormula = Lookup("Purchase Header".Posted WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(90140; "Line Status"; Option)
        {
            CalcFormula = Lookup("Purchase Header".Status WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(90141; "Line Budget Amount"; Decimal)
        {
            Editable = false;
        }
        field(90142; "Line Posting Date"; Date)
        {
            CalcFormula = Lookup("Purchase Header"."Posting Date" WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }

        field(90143; "Car Repair/Maintenance"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90144; "Vehicle Reg. No"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(90145; "Procurement Plan"; Code[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "The Procurement Plan"."No.";

            trigger OnValidate()
            var
                procurementplan: Record "The Procurement Plan";
            begin
                procurementplan.Reset();
                procurementplan.SetRange("No.", Rec."Procurement Plan");
                if procurementplan.FindFirst() then begin
                    Rec."Shortcut Dimension 2 Code" := procurementplan."Pillar Code";
                    Rec."Shortcut Dimension 1 Code" := procurementplan."Sub-office code";
                    Rec."Partner Code" := procurementplan."Partner Code";
                    Rec."Grant No." := procurementplan."Grant Code";
                    Rec."Activity Code" := procurementplan."Activity Code";
                end;
            end;
        }
        field(90146; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90147; "Procurement Method"; Option)
        {
            DataClassification = ToBeClassified;
            InitValue = "Direct Procurement";
            OptionCaption = '" ,Tender,RFQ,Direct Procurement,RFP"';
            OptionMembers = " ",Tender,RFQ,"Direct Procurement",RFP;
        }
    }
    var
        StandardText: Record "Standard Text";
        exp: Code[100];
}
