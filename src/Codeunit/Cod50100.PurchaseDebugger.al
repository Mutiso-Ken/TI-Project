codeunit 50100 "Purchase Debugger"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', true, true)]
    local procedure OnBeforePurchaseHeaderInsert(var Rec: Record "Purchase Header")
    begin
        // Log what's happening
        //Message('Document Type before insert: %1', Rec."Document Type");
        //Message('Page Context: %1', GetCurrentPageId());
    end;

    local procedure GetCurrentPageId(): Integer
    var
        AllObj: Record AllObj;
    begin
        AllObj.SetRange("Object Type", AllObj."Object Type"::Page);
        AllObj.SetRange("Object Name", 'Purchase Invoice');
        if AllObj.FindFirst() then
            exit(AllObj."Object ID");
        exit(0);
    end;
}