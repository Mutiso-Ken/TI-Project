table 29 "Vendor Registration Details"
{
    Caption = 'Vendor Registration Details';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Vendor ID"; Code[50])
        {
            Caption = 'Vendor ID';
        }
        field(2; "Suppliying Categories"; Text[1000])
        {
            Caption = 'Suppliying Categories';
        }
        field(3; "Business Name"; Text[1000])
        {
            Caption = 'Business Name';
        }
        field(4; "Postal Address"; Text[100])
        {
            Caption = 'Postal Address';
        }
        field(5; Town; Text[100])
        {
            Caption = 'Town';
        }
        field(6; Street; Text[100])
        {
            Caption = 'Street';
        }
        field(7; "Buiding Name"; Text[100])
        {
            Caption = 'Buiding Name';
        }
        field(8; "Office/Room Number"; Text[100])
        {
            Caption = 'Office/Room Number';
        }
        field(9; "Floor Number"; Text[100])
        {
            Caption = 'Floor Number';
        }
        field(10; "Telephone Number"; Text[100])
        {
            Caption = 'Telephone Number';
        }
        field(11; "Email Address"; Text[100])
        {
            Caption = 'Email Address';
        }
        field(12; "Management Personnel"; Text[100])
        {
            Caption = 'Management Personnel';
        }
        field(13; "Chief Executive"; Text[100])
        {
            Caption = 'Chief Executive';
        }
        field(14; Secretary; Text[100])
        {
            Caption = 'Secretary';
        }
        field(15; "General Manager"; Text[100])
        {
            Caption = 'General Manager';
        }
        field(16; "Founded On"; Text[100])
        {
            Caption = 'Founded On';
        }
        field(17; "Organizational Chart Link"; Text[2048])
        {
            Caption = 'Organizational Chart Link';
        }
        field(18; "Technological Innovation"; Text[2048])
        {
            Caption = 'Technological Innovation';
        }
        field(19; "Business Premises"; Text[2000])
        {
            Caption = 'Business Premises';
        }
        field(20; "Plot Number"; Text[100])
        {
            Caption = 'Plot Number';
        }
        field(21; "Street Road"; Text[100])
        {
            Caption = 'Street Road';
        }
        field(22; "Probity Postal Address"; Text[200])
        {
            Caption = 'Probity Postal Address';
        }
        field(23; "Probity Telephone"; Text[100])
        {
            Caption = 'Probity Telephone';
        }
        field(24; "Probity Email"; Text[100])
        {
            Caption = 'Probity Email';
        }
        field(25; "Nature Of Business"; Text[2000])
        {
            Caption = 'Nature Of Business';
        }
        field(26; "Trade License Number"; Text[100])
        {
            Caption = 'Trade License Number';
        }
        field(27; "Trade License Expiry Date"; Date)
        {
            Caption = 'Trade License Expiry Date';
        }
        field(28; "Max Business Value"; Decimal)
        {
            Caption = 'Max Business Value';
            DecimalPlaces = 0 : 0;
        }
        field(29; "Bank Name"; Text[200])
        {
            Caption = 'Bank Name';
        }
        field(30; "Account Name"; Text[200])
        {
            Caption = 'Account Name';
        }
        field(31; "Account Number"; Text[50])
        {
            Caption = 'Account Number';
        }
        field(32; "Bank Branch"; Text[100])
        {
            Caption = 'Bank Branch';
        }
        field(33; "Swift Code"; Text[50])
        {
            Caption = 'Swift Code';
        }
        field(34; "Branch Code"; Text[50])
        {
            Caption = 'Branch Code';
        }
        field(35; "Bank Currency"; Code[10])
        {
            Caption = 'Bank Currency';
        }
        field(36; "Cat_A1_Office_Stationery"; Boolean)
        {
            Caption = 'Category 01 - Supply of Office Stationery';
        }
        field(37; "Cat_A2_PrintedStationery"; Boolean)
        {
            Caption = 'Category 02 - Supply of Printed Stationery';
        }
        field(38; "Cat_A3_MineralWater"; Boolean)
        {
            Caption = 'Category 03 - Supply of Mineral Water';
        }
        field(39; "Cat_A4_ComputerAccessories"; Boolean)
        {
            Caption = 'Category 04 - Supply of Computers/Accessories';
        }
        field(40; "Cat_A5_BrandedTShirts"; Boolean)
        {
            Caption = 'Category 05 - Supply of Branded T-shirt, Shirts Blouses,and Jumpers';
        }
        field(41; "Cat_A6_FurnitureFittings"; Boolean)
        {
            Caption = 'Category 06 - Supply of Furniture & Fittings';
        }
        field(42; "Cat_A7_MetallicCabinets"; Boolean)
        {
            Caption = 'Category 07 - Supply of Metallic Cabinets';
        }
        field(43; "Cat_A8_MoneyCountingMachines"; Boolean)
        {
            Caption = 'Category 08 - Supply of Money Counting Machines';
        }
        field(44; "Doc Certificate Registration"; Boolean)
        {
            Caption = 'Doc Certificate Registration';
        }
        field(45; "Certificate Registration Path"; Text[2048])
        {
            Caption = 'Certificate Registration Path';
        }
        field(46; "Certificate Registration Name"; Text[255])
        {
            Caption = 'Certificate Registration Name';
        }
        field(47; "Doc company Profile"; Boolean)
        {
            Caption = 'Doc company Profile';
        }
        field(48; "Company Profile Path"; Text[2048])
        {
            Caption = 'Company Profile Path';
        }
        field(49; "Company Profile Name"; Text[255])
        {
            Caption = 'Company Profile Name';
        }
        field(50; "Doc Trade License"; Boolean)
        {
            Caption = 'Doc Trade License';
        }
        field(51; "Trade License Path"; Text[2048])
        {
            Caption = 'Trade License Path';
        }
        field(52; "Trade License Name"; Text[255])
        {
            Caption = 'Trade License Name';
        }
        field(53; "Doc Tax Compliance"; Boolean)
        {
            Caption = 'Doc Tax Compliance';
        }
        field(54; "Tax Compliance Path"; Text[2048])
        {
            Caption = 'Tax Compliance Path';
        }
        field(55; "Tax Compliance Name"; Text[255])
        {
            Caption = 'Tax Compliance Name';
        }
        field(56; "Doc NCA Certificate"; Boolean)
        {
            Caption = 'Doc NCA Certificate';
        }
        field(57; "NCA Certificate Path"; Text[2048])
        {
            Caption = 'NCA Certificate Path';
        }
        field(58; "NCA Certificate Name"; Text[255])
        {
            Caption = 'NCA Certificate Name';
        }
        field(59; "Doc Bank Statements"; Boolean)
        {
            Caption = 'Doc Bank Statements';
        }
        field(60; "Bank Statements Path"; Text[2048])
        {
            Caption = 'Bank Statements Path';
        }
        field(61; "Bank Statements Name"; Text[255])
        {
            Caption = 'Bank Statements Name';
        }
        field(62; "Doc Recommendation Letters"; Boolean)
        {
            Caption = 'Doc Recommendation Letters';
        }
        field(63; "Recommendation Letters Path"; Text[2048])
        {
            Caption = 'Recommendation Letters Path';
        }
        field(64; "Recommendation Letters Name"; Text[255])
        {
            Caption = 'Recommendation Letters Name';
        }
        field(65; "Doc Regulatory Certificates"; Boolean)
        {
            Caption = 'Doc Regulatory Certificates';
        }
        field(66; "Regulatory Certificates Path"; Text[2048])
        {
            Caption = 'Regulatory Certificates Path';
        }
        field(67; "Regulatory Certificates Name"; Text[255])
        {
            Caption = 'Regulatory Certificates Name';
        }
        field(68; "Doc RCK Payment Receipt"; Boolean)
        {
            Caption = 'Doc Payment Receipt';
        }
        field(69; "RCK Payment Receipt Path"; Text[2048])
        {
            Caption = 'Payment Receipt Path';
        }
        field(70; "RCK Payment Receipt Name"; Text[255])
        {
            Caption = 'Payment Receipt Name';
        }
        field(71; "Doc Organizational Chart"; Boolean)
        {
            Caption = 'Doc Organizational Chart';
        }
        field(72; "Organizational Chart Path"; Text[2048])
        {
            Caption = 'Organizational Chart Path';
        }
        field(73; "Organizational Chart Name"; Text[255])
        {
            Caption = 'Organizational Chart Name';
        }
        field(74; "Doc Audited Accounts"; Boolean)
        {
            Caption = 'Doc Audited Accounts';
        }
        field(75; "Audited Accounts Path"; Text[2048])
        {
            Caption = 'Audited Accounts Path';
        }
        field(76; "Audited Accounts Name"; Text[255])
        {
            Caption = 'Audited Accounts Name';
        }
        field(77; "Credit Period"; Text[2000])
        {
            Caption = 'Credit Period';
        }
        field(78; "Financial Capability"; Text[2000])
        {
            Caption = 'Financial Capability';
        }
        field(79; "Public Company"; Boolean)
        {
            Caption = 'Public Company';
        }
        field(80; "Private Company"; Boolean)
        {
            Caption = 'Private Company';
        }
        field(81; "Nominal Capital"; Decimal)
        {
            Caption = 'Nominal Capital';
            DecimalPlaces = 0 : 0;
        }
        field(82; "Issued Capital"; Decimal)
        {
            Caption = 'Issued Capital';
            DecimalPlaces = 0 : 0;
        }
        field(83; "Doc Declarant ID"; Boolean)
        {
            Caption = 'Doc Declarant ID';
        }
        field(84; "Declarant ID Path"; Text[2048])
        {
            Caption = 'Declarant ID Path';
        }
        field(85; "Declarant ID Name"; Text[255])
        {
            Caption = 'Declarant ID Name';
        }
        field(86; "Doc Declarant PIN"; Boolean)
        {
            Caption = 'Doc Declarant PIN';
        }
        field(87; "Declarant PIN Path"; Text[2048])
        {
            Caption = 'Declarant PIN Path';
        }
        field(88; "Declarant PIN Name"; Text[255])
        {
            Caption = 'Declarant PIN Name';
        }
        field(89; "Doc Applicant Signature"; Boolean)
        {
            Caption = 'Doc Applicant Signature';
        }
        field(90; "Applicant Signature Path"; Text[2048])
        {
            Caption = 'Applicant Signature Path';
        }
        field(91; "Applicant Signature Name"; Text[255])
        {
            Caption = 'Applicant Signature Name';
        }
        field(92; "Doc Sworn Signature"; Boolean)
        {
            Caption = 'Doc Sworn Signature';
        }
        field(93; "Sworn Signature Path"; Text[2048])
        {
            Caption = 'Sworn Signature Path';
        }
        field(94; "Sworn Signature Name"; Text[255])
        {
            Caption = 'Sworn Signature Name';
        }
        field(95; "Code of Conduct"; Boolean)
        {
            Caption = 'Code of Conduct';
        }
        field(96; "Declarant Name"; Text[200])
        {
            Caption = 'Declarant Name';
        }
        field(97; "Declarant Position"; Text[200])
        {
            Caption = 'Declarant Position';
        }
        field(98; "Declaration Date"; Date)
        {
            Caption = 'Declaration Date';
        }
        field(99; "Sworn Statement"; Boolean)
        {
            Caption = 'Sworn Statement';
        }
        field(100; "Vendor Status"; Text[100])
        {
            Caption = 'Vendor Status';
        }
        field(101; "Sworn Date"; Date)
        {
            Caption = 'Sworn Date';
        }
        field(102; "Applicant Name"; Text[100])
        {
            Caption = 'Applicant Name';
        }
        field(103; "Represented By"; Text[100])
        {
            Caption = 'Represented By';
        }
        field(104; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = New,"In Review",Approved,Rejected;
        }
        field(105; "Cat_A9_Photocopier"; Boolean)
        {
            Caption = 'Category 09 - Supply of Photocopier';
        }
        field(106; "Cat_A10_SupplyofPrinters"; Boolean)
        {
            Caption = 'Category 10 - Supply of Printers';
        }
        field(107; "Cat_A11_FirewallNetwork"; Boolean)
        {
            Caption = 'Category 11 - Supply of Installation of Firewall & Network Switches';
        }
        field(108; "Cat_A12_CallCenter"; Boolean)
        {
            Caption = 'Category 12 - Supply and Installation of a Call Centre';
        }
        field(109; "Cat_B13_OfficeCleaning"; Boolean)
        {
            Caption = 'Category 13 - Provision of Office cleaning services';
        }
        field(110; "Cat_B14_TimeLockServicing"; Boolean)
        {
            Caption = 'Category 14 - Time Lock Servicing';
        }
        field(111; "Cat_B15_FireExtinguishers"; Boolean)
        {
            Caption = 'Category 15 - Fire Extinguishers Maintenance Services';
        }
        field(112; "Cat_B16_PhotocopierMachine"; Boolean)
        {
            Caption = 'Category 16 - Servicing of Photocopier Machine';
        }
        field(113; "Cat_B17_MotorVehicleBikes"; Boolean)
        {
            Caption = 'Category 17 - Servicing of Motor Vehicle and Motor Bikes';
        }
        field(114; "Cat_B18_Printers"; Boolean)
        {
            Caption = 'Category 18 - Servicing of Printers';
        }
        field(115; "Cat_B19_Generators"; Boolean)
        {
            Caption = 'Category 19 - Servicing of Generators';
        }
        field(116; "Cat_B20_MoneyCountingMachines"; Boolean)
        {
            Caption = 'Category 20 - Servicing of Money Counting Machines';
        }
        field(117; "Cat_B21_SanitaryDisposal"; Boolean)
        {
            Caption = 'Category 21 - Provision of Sanitary disposal & Fumigation services';
        }
        field(118; "Cat_B22_SecurityGuarding"; Boolean)
        {
            Caption = 'Category 22 - Provision of Security and Guarding Services';
        }
        field(119; "Cat_B23_TeamBuilding"; Boolean)
        {
            Caption = 'Category 23 - Provision of Team building services';
        }
        field(120; "Cat_B24_StructuredCabling"; Boolean)
        {
            Caption = 'Category 24 - Provision of Structured Cabling System and Networking Works';
        }
        field(121; "Cat_B25_OfficePartitioning"; Boolean)
        {
            Caption = 'Category 25 - Provision of Office partitioning';
        }
        field(122; "Cat_B26_OutsideCatering"; Boolean)
        {
            Caption = 'Category 26 - Provision of Outside Catering service,advanced public address system,tents,seats, and decoration services';
        }
        field(123; "Cat_B27_Electrical"; Boolean)
        {
            Caption = 'Category 27 - Provision of Electrical services';
        }




        field(124; "Cat_B28_PlumbingDrainage"; Boolean)
        {
            Caption = 'Category 28 - Provision of Plumbing and drainage works/services';
        }
        field(125; "Cat_B29_GeneralRepairs"; Boolean)
        {
            Caption = 'Category 29 - Provision of General repairs and maintenance';
        }
        field(126; "Cat_B30_CarTracking"; Boolean)
        {
            Caption = 'Category 30 - Provision of Car tracking services';
        }
        field(127; "Cat_B31_BulkSMS"; Boolean)
        {
            Caption = 'Category 31 - Provision of Bulk SMS services';
        }
        field(128; "Cat_B32_AssetTagging"; Boolean)
        {
            Caption = 'Category 32 - Provision of Asset tagging bar codes and tagging services';
        }
        field(129; "Cat_B33_DesignArtwork"; Boolean)
        {
            Caption = 'Category 33 - Professional Design of Artwork, Branding and supply of promotional material';
        }
        field(130; "Cat_B34_InsuranceCovers"; Boolean)
        {
            Caption = 'Category 34 - Provision of Insurance covers';
        }
        field(131; "Cat_C35_SystemAudit"; Boolean)
        {
            Caption = 'Category 35 - ICT System Audit';
        }
        field(132; "Cat_C36_ExternalAuditors"; Boolean)
        {
            Caption = 'Category 36 - External Auditors services';
        }
        field(133; "Cat_C37_DebtCollectors"; Boolean)
        {
            Caption = 'Category 37 - Provision of Debt collectors';
        }
        field(134; "Cat_C38_Valuers"; Boolean)
        {
            Caption = 'Category 38 - Provision of Valuers';
        }
        field(135; "Cat_C39_Auctioneers"; Boolean)
        {
            Caption = 'Category 39 - Provision of Auctioneers';
        }
        field(136; "Cat_C40_CashTransit"; Boolean)
        {
            Caption = 'Category 40 - Cash in Transit Services';
        }
        field(137; "Cat_C41_LegalServices"; Boolean)
        {
            Caption = 'Category 41 - Legal Services';
        }
        field(138; "Cat_C42_Consultancy"; Boolean)
        {
            Caption = 'Category 42 - Professional Consultancy';
        }
        field(139; "Cat_C43_QuantitySurveyors"; Boolean)
        {
            Caption = 'Category 43 - Provision of Quantity surveyors';
        }
        field(140; "Cat_C44_CCTVMaintenance"; Boolean)
        {
            Caption = 'Category 44 - CCTV maintenance';
        }
        field(141; "Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
        }
        field(142; "Payment Phone Number"; Text[20])
        {
            Caption = 'Payment Phone Number';
        }
        field(143; "Mpesa Receipt Number"; Text[50])
        {
            Caption = 'Mpesa Receipt Number';
        }
        field(144; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(145; "Category Count"; Integer)
        {
            Caption = 'Category Count';
        }
        field(146; "Payment Status"; Option)
        {
            Caption = 'Payment Status';
            OptionMembers = New,Paid;
        }
    }
    keys
    {
        key(PK; "Vendor ID")
        {
            Clustered = true;
        }
    }
}
