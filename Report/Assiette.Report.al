report 50069 Assiette
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/Assiette.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Code"; "Code")
        {
            DataItemTableView = SORTING("Table No", "Field No", Code) WHERE("Table No" = CONST(27), "Field No" = CONST(50074));
            column(Code_Table_No; "Table No")
            {
            }
            column(Code_Field_No; "Field No")
            {
            }
            column(Code_Code; Code)
            {
            }
            dataitem(Item; Item)
            {
                DataItemLink = Assiette = FIELD(Code);
                column(QStock; QStock)
                {
                }
                column(Item__No__; "No.")
                {
                }
                column(VStock; VStock)
                {
                }
                column(QCmdBefore; QCmdBefore)
                {
                }
                column(VCmdBefore; VCmdBefore)
                {
                }
                column(QCmdAfter; QCmdAfter)
                {
                }
                column(VCmdAfter; VCmdAfter)
                {
                }
                column(UnitStock; UnitStock)
                {
                }
                column(UnitCmdBefore; UnitCmdBefore)
                {
                }
                column(UnitCmdAfter; UnitCmdAfter)
                {
                }
                column(DtEnd; DtEnd)
                {
                }
                column(Item_Assiette; Assiette)
                {
                }
                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemLink = "No." = FIELD("No.");
                    DataItemTableView = WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Qty. to Receive" = FILTER(> 0));
                    column(Purchase_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Purchase_Line__Expected_Receipt_Date_; "Expected Receipt Date")
                    {
                    }
                    column(Purchase_Line__Qty__to_Receive_; "Qty. to Receive")
                    {
                    }
                    column(Purchase_Line__Unit_Cost__LCY__; "Unit Cost (LCY)")
                    {
                    }
                    column(Purchase_Line_Document_Type; "Document Type")
                    {
                    }
                    column(Purchase_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Purchase_Line_No_; "No.")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    QStock := 0;
                    VStock := 0;
                    QCmdBefore := 0;
                    VCmdBefore := 0;
                    QCmdAfter := 0;
                    VCmdAfter := 0;
                    UnitStock := 0;
                    UnitCmdBefore := 0;
                    UnitCmdAfter := 0;


                    ItemLedg.Reset;
                    ItemLedg.SetRange("Item No.", "No.");
                    ItemLedg.SetFilter("Remaining Quantity", '>0');
                    if ItemLedg.FindSet then
                        repeat
                            ItemLedg.CalcFields("Cost Amount (Actual)");
                            QStock += ItemLedg."Remaining Quantity";
                            VStock += ItemLedg."Remaining Quantity" * (ItemLedg."Cost Amount (Actual)" / ItemLedg.Quantity);
                        until ItemLedg.Next = 0;

                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SetRange(Type, PurchLine.Type::Item);
                    PurchLine.SetRange("No.", "No.");
                    PurchLine.SetFilter("Qty. to Receive", '>0');
                    PurchLine.SetFilter("Expected Receipt Date", '<%1', Today);
                    if PurchLine.FindSet then
                        repeat
                            QCmdBefore += PurchLine."Qty. to Receive";
                            VCmdBefore += PurchLine."Qty. to Receive" * (PurchLine."Unit Cost (LCY)" + PurchLine."Frais annexes estimatifs unit");
                        until PurchLine.Next = 0;

                    PurchLine.Reset;
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SetRange(Type, PurchLine.Type::Item);
                    PurchLine.SetRange("No.", "No.");
                    PurchLine.SetFilter("Qty. to Receive", '>0');
                    PurchLine.SetFilter("Expected Receipt Date", '%1..%2', Today, DtEnd);
                    if PurchLine.FindSet then
                        repeat
                            QCmdAfter += PurchLine."Qty. to Receive";
                            VCmdAfter += PurchLine."Qty. to Receive" * (PurchLine."Unit Cost (LCY)" + PurchLine."Frais annexes estimatifs unit");
                        until PurchLine.Next = 0;

                    if QStock <> 0 then
                        UnitStock := VStock / QStock;
                    if QCmdBefore <> 0 then
                        UnitCmdBefore := VCmdBefore / QCmdBefore;
                    if QCmdAfter <> 0 then
                        UnitCmdAfter := VCmdAfter / QCmdAfter;

                    QStockAss += QStock;
                    VStockAss += VStock;
                    QCmdBeforeAss += QCmdBefore;
                    VCmdBeforeAss += VCmdBefore;
                    QCmdAfterAss += QCmdAfter;
                    VCmdAfterAss += VCmdAfter;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Code_Code_Control1000000010; Code.Code)
                {
                }
                column(QStockAss; QStockAss)
                {
                }
                column(VStockAss; VStockAss)
                {
                }
                column(QCmdBeforeAss; QCmdBeforeAss)
                {
                }
                column(VCmdBeforeAss; VCmdBeforeAss)
                {
                }
                column(QCmdAfterAss; QCmdAfterAss)
                {
                }
                column(VCmdAfterAss; VCmdAfterAss)
                {
                }
                column(QAss; QAss)
                {
                }
                column(VAss; VAss)
                {
                }
                column(CoutUnitAss; CoutUnitAss)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                var
                    items: Record Item;
                begin
                    QAss := QStockAss + QCmdBeforeAss + QCmdAfterAss;
                    VAss := VStockAss + VCmdBeforeAss + VCmdAfterAss;
                    if QAss <> 0 then
                        CoutUnitAss := VAss / QAss
                    else
                        CoutUnitAss := 0;

                    if CoutUnitAss > 0 then begin
                        items.Reset;
                        items.SetRange(Assiette, Code.Code);
                        if items.FindSet then
                            repeat
                                StCostWorksheet.Init;
                                StCostWorksheet.Validate("Standard Cost Worksheet Name", 'ASSIETTE');
                                StCostWorksheet.Validate(Type, StCostWorksheet.Type::Item);
                                StCostWorksheet.Validate("No.", items."No.");
                                StCostWorksheet.Validate("New Standard Cost", CoutUnitAss);
                                StCostWorksheet.Insert;
                            until items.Next = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                QStockAss := 0;
                VStockAss := 0;
                QCmdBeforeAss := 0;
                VCmdBeforeAss := 0;
                QCmdAfterAss := 0;
                VCmdAfterAss := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(DtEnd; DtEnd)
                {
                    Caption = 'Date de fin';
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
        QStock: Decimal;
        VStock: Decimal;
        UnitStock: Decimal;
        QCmdBefore: Decimal;
        VCmdBefore: Decimal;
        UnitCmdBefore: Decimal;
        QCmdAfter: Decimal;
        VCmdAfter: Decimal;
        UnitCmdAfter: Decimal;
        QStockAss: Decimal;
        VStockAss: Decimal;
        QCmdBeforeAss: Decimal;
        VCmdBeforeAss: Decimal;
        QCmdAfterAss: Decimal;
        VCmdAfterAss: Decimal;
        CoutUnitAss: Decimal;
        ItemLedg: Record "Item Ledger Entry";
        PurchLine: Record "Purchase Line";
        QAss: Decimal;
        VAss: Decimal;
        DtEnd: Date;
        StCostWorksheet: Record "Standard Cost Worksheet";
}

