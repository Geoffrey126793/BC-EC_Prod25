codeunit 50029 "Call WS UpdateOF"
{
    TableNo = "Production Order";

    trigger OnRun()
    var
        Prod: Record "Production Order";
        RRefresh: Report "Refresh Production Order";
        BOMH: Record "Production BOM Header";
        Item: Record Item;
        cuProd: Codeunit "Integration Tft and Prod";

        Client: HttpClient;
        Response: HttpResponseMessage;
        TypeHelper: Codeunit "Type Helper";
        Url: Text;
        tmp: text;
    begin
        // Mise à jour de l'OF
        tmp := Rec."No.";
        Url := 'http://intranet.europacuisson.local:43215' +
               '/NAVToVP/UpdateOF?No=' +
               TypeHelper.UrlEncode(tmp);

        if not Client.Get(Url, Response) then
            Error('Impossible de contacter NAVToVP pour UpdateOF.');

        if not Response.IsSuccessStatusCode() then
            Error(
                'Erreur NAVToVP UpdateOF : HTTP %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

        // Mise à jour des composants de l'OF
        Clear(Response);

        Url := 'http://intranet.europacuisson.local:43215' +
               '/NAVToVP/UpdateOFComponents?No=' +
               TypeHelper.UrlEncode(tmp);

        if not Client.Get(Url, Response) then
            Error('Impossible de contacter NAVToVP pour UpdateOFComponents.');

        if not Response.IsSuccessStatusCode() then
            Error(
                'Erreur NAVToVP UpdateOFComponents : HTTP %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

    end;

    var

}

