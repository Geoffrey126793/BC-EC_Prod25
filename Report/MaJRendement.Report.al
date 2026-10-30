report 50094 "MaJ Rendement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/rdlc/MaJRendement.rdlc';

    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = SORTING("No.") ORDER(Descending) WHERE(Blocked = CONST(false), "Production BOM No." = FILTER(<> ''));
            RequestFilterFields = "No.";
            column(No_Item; Item."No.")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(Version; Version)
            {
            }
            column(Cadence; Cadence)
            {
            }
            dataitem("ABC - Parametres"; "ABC - Parametres")
            {
                DataItemTableView = WHERE("Imputation Ressource" = CONST(Direct), Activity = FILTER(<> 'S*'), "Rendement effectif" = FILTER(> 0), Rendement = CONST(true), "Rendement nominal" = FILTER(<> 0));

                trigger OnAfterGetRecord()
                begin
                    "ABC - Parametres".CalcFields("Rendement nominal");
                    if "ABC - Parametres"."Rendement effectif" < Rendements then
                        Rendements := "ABC - Parametres"."Rendement effectif";
                    if "ABC - Parametres"."Rendement nominal" < RendementNominal then
                        RendementNominal := "ABC - Parametres"."Rendement nominal";
                    //MESSAGE('%1  %2   %3',Item."No.",RendementNominal,REndement);
                end;

                trigger OnPreDataItem()
                begin

                    "ABC - Parametres".SetRange("Production BOM No", Item."Production BOM No.");
                    "ABC - Parametres".SetRange("BOM Version", Version);
                end;
            }
            dataitem(ABCPrecedent; "ABC - Parametres")
            {
                DataItemTableView = WHERE("Imputation Ressource" = CONST(Direct), Activity = FILTER(<> 'S*'), "Rendement effectif" = FILTER(> 0), Rendement = CONST(true), "Rendement nominal" = FILTER(<> 0));

                trigger OnAfterGetRecord()
                begin
                    if not ((CopyStr(Item."No.", 1, 5) = '1-IQF') or (CopyStr(Item."No.", 1, 5) = '1-FSV')) then
                        CurrReport.Skip;
                    //MESSAGE('%1   %2',Rendements,ABCPrecedent."Rendement effectif");
                    ABCPrecedent.CalcFields("Rendement nominal");
                    if ABCPrecedent."Rendement effectif" < Rendements then
                        Rendements := ABCPrecedent."Rendement effectif";
                    if ABCPrecedent."Rendement nominal" < RendementNominal then
                        RendementNominal := ABCPrecedent."Rendement nominal";
                end;

                trigger OnPreDataItem()
                begin
                    ProdBOMLine.Reset;
                    ProdBOMLine.SetRange("Production BOM No.", Item."Production BOM No.");
                    ProdBOMLine.SetRange("Version Code", Version);
                    ProdBOMLine.SetFilter("No.", '5-FRS*|5-IQF*|5-FSV*');
                    if not ProdBOMLine.FindFirst then begin
                        ABCPrecedent.SetRange("Production BOM No", 'Z');
                    end
                    else begin
                        ItemPrecedent.Get(ProdBOMLine."No.");
                        Version := VersionMgt.GetBOMVersion(ItemPrecedent."Production BOM No.", Today, false);
                        ABCPrecedent.SetRange("Production BOM No", ItemPrecedent."Production BOM No.");
                        ABCPrecedent.SetRange("BOM Version", Version);
                    end;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                column(Rendement; Rendements)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //MESSAGE('%1  %2   %3',Item."No.",RendementNominal,REndement);
                    if (Rendements < 900000) and (Item.Cadence <> Rendements) then begin
                        Item.Cadence := Rendements;
                        Item.Modify(true);
                    end;

                    if (not Item.Blocked) and (RendementNominal <> 0) and (RendementNominal < 50000) then begin
                        Xl.NewRow();
                        Xl.AddColumn(Item."No.", false, '', false, false, false, '', Xl."Cell Type"::Text);
                        Xl.AddColumn(Item.Description, false, '', false, false, false, '', Xl."Cell Type"::Text);
                        Xl.AddColumn('ACTIVE', false, '', false, false, false, '', Xl."Cell Type"::Text);
                        Xl.AddColumn(Item."Item Category Code", false, '', false, false, false, '', Xl."Cell Type"::Text);

                        Xl.AddColumn(Format(RendementNominal), false, '', false, false, false, '', Xl."Cell Type"::Number);
                        Xl.AddColumn(Format((Rendements / RendementNominal) * 100, 0, '<Precision,2><Integer><Decimals>'), false, '', false, false, false, '', Xl."Cell Type"::Number);
                        Xl.AddColumn(Format(Item."Kg par heartbeat"), false, '', false, false, false, '', Xl."Cell Type"::Number);
                        Xl.AddColumn(Format(Item."Piece par heartbeat"), false, '', false, false, false, '', Xl."Cell Type"::Number);
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if not Item.IsMfgItem then
                    CurrReport.Skip;
                Version := VersionMgt.GetBOMVersion(Item."Production BOM No.", Today, false);
                Rendements := 999999;
                RendementNominal := 999999;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        outstream: OutStream;
        fichier: File;
    begin
        //xFile.CLOSE();
        Xl.CreateNewBook('Items');
        Xl.WriteSheet('Items', CompanyName, UserId);
        Xl.CloseBook();
        fichier.Create('\\srvnavision.europacuisson.local\NavisionTemp\ItemsPatchOEE.xlsx');
        fichier.CreateOutStream(outstream);
        Xl.SaveToStream(outstream, true);
        fichier.Close;
    end;

    trigger OnPreReport()
    begin
        Clear(xFile);
        //xFile.TEXTMODE := TRUE;
        //xFile.WRITEMODE := TRUE;
        //xFile.CREATE('\\srvnavision.europacuisson.local\NavisionTemp\PatchOEE\ItemsPatchOEE.csv');
        Xl.Reset;
        Xl.NewRow();
        Xl.AddColumn('Product code', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('Description', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('Status', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('Product group', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('Units/hour (kg)', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('OEE Target (%)', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('kg /unit', false, '', false, false, false, '', Xl."Cell Type"::Text);
        Xl.AddColumn('nr of units per heartbeat', false, '', false, false, false, '', Xl."Cell Type"::Text);
    end;

    var
        VersionMgt: Codeunit VersionManagement;
        Version: Code[20];
        Rendements: Decimal;
        xFile: File;
        Txt: Text;
        RendementNominal: Decimal;
        ItemPrecedent: Record Item;
        ProdBOMLine: Record "Production BOM Line";
        Xl: Record "Excel Buffer" temporary;
}

