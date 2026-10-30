codeunit 50031 "Call WS"
{

    trigger OnRun()
    var
        Items: Record Item;
    begin
        //UpdateItem('5-FRS-01001');
        //UpdateOF('WB-00512108');
        Items.Reset;
        Items.SetRange(Blocked, false);
        if Items.FindFirst then
            repeat
                UpdateItem(Items."No.");
            until Items.Next = 0;

        Message('ok');
    end;

    var

        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        Url: Text;
        TypeHelper: Codeunit "Type Helper";

    [Scope('OnPrem')]
    procedure test1()
    begin
    end;

    [Scope('OnPrem')]
    procedure UpdateItem(No: Code[20])
    begin
        Commit;
        Url := 'http://intranet.europacuisson.local:43215' +
            '/NAVToVP/UpdateItem?No=' + No;

        if not HttpClient.Get(Url, HttpResponse) then
            Error('Impossible de contacter le service NAVToVP.');

        if not HttpResponse.IsSuccessStatusCode() then
            Error(
                'Erreur NAVToVP UpdateItem. Code HTTP : %1 - %2',
                HttpResponse.HttpStatusCode(),
                HttpResponse.ReasonPhrase());



    end;

    [Scope('OnPrem')]
    procedure UpdateOF(No: Code[20])
    begin


    end;

    [Scope('OnPrem')]
    procedure CmdVenteDel(ID: Text[50])
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        TypeHelper: Codeunit "Type Helper";
        Url: Text;
    begin
        Url := 'http://intranet.europacuisson.local:43215' +
                '/NAVToVP/DelCmdVente?ID=' +
                TypeHelper.UrlEncode(ID);

        if not Client.Get(Url, Response) then
            Error('Impossible de contacter le service NAVToVP.');

        if not Response.IsSuccessStatusCode() then
            Error(
                'Erreur NAVToVP DelCmdVente : HTTP %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());
    end;

    [Scope('OnPrem')]
    procedure SetAlerte(OFNo: Text; Missing: Text)

    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        TypeHelper: Codeunit "Type Helper";
        Url: Text;
    begin
        Url := 'http://intranet.europacuisson.local:43215' +
            '/ModifVP/SetAlerte?NumOF=' +
            TypeHelper.UrlEncode(OFNo) +
            '&Missing=' +
            TypeHelper.UrlEncode(Missing);

        if not Client.Get(Url, Response) then
            Error('Impossible de contacter le service ModifVP.');

        if not Response.IsSuccessStatusCode() then
            Error(
                'Erreur ModifVP SetAlerte : HTTP %1 - %2',
                Response.HttpStatusCode(),
                Response.ReasonPhrase());

    end;
}

