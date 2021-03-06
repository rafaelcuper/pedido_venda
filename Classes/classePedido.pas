unit classePedido;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait ,SysUtils, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,Datasnap.DBClient,Vcl.Dialogs;

type
  TPedido = class
  private
    FNumeroPedido : integer;
    FCodigoCliente: integer;
    FDataEmissao  : Tdate;
    FValorTotal   : Currency;
    FQry          : TFDQuery;
    Conexao       : TFDConnection;

    procedure SetNumeroPedido (const Value: integer);
    procedure SetCodigoCliente(const Value: integer);
    procedure SetDataEmissao  (const Value: Tdate);
    procedure SetValorTotal   (const Value: Currency);
    procedure SetQry          (const Value: TFDQuery);


  public
    Itens : TClientDataSet;

    constructor Create(Conn: TFDConnection);

    property NumeroPedido  : integer  read FNumeroPedido  write SetNumeroPedido;
    property ValorTotal    : Currency read FValorTotal    write SetValorTotal;
    property DataEmissao   : TDate    read FDataEmissao   write SetDataEmissao;
    property CodigoCliente : integer  read FCodigoCliente write SetCodigoCliente;
    property Qry           : TFDQuery read FQry           write SetQry;


    function Selecionar(Numped: string):Boolean;
    function Inserir : boolean;
    function Alterar(NumPed:string)  : boolean;
    function Deletar(numped: string) : boolean;

  end;

implementation

{ TPedido }

function TPedido.Alterar(NumPed:string): boolean;
begin
  with Conexao do
  begin
    try
      StartTransaction;
      with Qry do
      begin
        Close;
        sql.Clear;
        sql.Text:= ' UPDATE PEDIDO SET '+
                      ' DATA_EMISSAO = :DATA_EMISSAO, '+
                      ' CODIGO_CLIENTE = :CODIGO_CLIENTE, ' +
                      ' VALOR_TOTAL = :VALOR_TOTAL '+
                      ' WHERE NUMERO_PEDIDO = :NUMPED ';
         ParamByName('NUMPED').Value         := NumPed;
         ParamByName('DATA_EMISSAO').Value   := FormatDateTime('yyyy-mm-dd',FDataEmissao);
         ParamByName('CODIGO_CLIENTE').Value := FCodigoCliente;
         ParamByName('VALOR_TOTAL').Value    := FValorTotal;

         ExecSQL;
      end;

      with Qry do
      begin
        Close;
        sql.Clear;
        sql.Text:= ' DELETE FROM PEDIDO_PRODUTO '+
                      ' WHERE NUMERO_PEDIDO = :NUMPED ';
        ParamByName('NUMPED').Value := FNumeroPedido;
        ExecSQL;
      end;

      with Itens do
      begin
        if RecordCount > 0 then
        begin
          First;

          while not eof do
          begin
            with Qry do
            begin
              Close;
              sql.Clear;
              sql.Add(' INSERT INTO PEDIDO_PRODUTO  '+
                        ' (NUMERO_PEDIDO,CODIGO_PRODUTO,QUANTIDADE,VALOR_UNITARIO,VALOR_TOTAL) VALUES '+
                        ' (:NUMERO_PEDIDO,:CODIGO_PRODUTO,:QUANTIDADE,:VALOR_UNITARIO,:VALOR_TOTAL)');
              ParamByName('NUMERO_PEDIDO').Value  := FNumeroPedido;
              ParamByName('CODIGO_PRODUTO').Value := Itens.FieldByName('codigo_produto').AsVariant;
              ParamByName('QUANTIDADE').Value     := Itens.FieldByName('quantidade').AsVariant;
              ParamByName('VALOR_UNITARIO').Value := Itens.FieldByName('valor_unitario').AsVariant;
              ParamByName('VALOR_TOTAL').Value    := Itens.FieldByName('valor_total').AsVariant;
              ExecSQL;
            end;

            Next;
          end;
        end;
      end;
      result:= true;
      Commit;
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message );
        Rollback;
        Result:= false;
      end;
    end;
  end;
end;

constructor TPedido.Create(Conn: TFDConnection);
begin
  Conexao                 := Conn;

  Qry                     := TFDQuery.Create(nil);
  Qry.Connection          := Conexao;

  Itens := TClientDataSet.Create(nil);
end;

function TPedido.Deletar(numped: string): boolean;
begin
   with Conexao do
   begin
     try
       StartTransaction;

       with Qry do
       begin
         Close;
         sql.Clear;
         sql.Text:= ' DELETE FROM PEDIDO_PRODUTO '+
                       ' WHERE NUMERO_PEDIDO = :NUMPED ';
         ParamByName('NUMPED').Value := numped;
         ExecSQL;
       end;

       with Qry do
       begin
         Close;
         sql.Clear;
         sql.Text:= ' DELETE FROM PEDIDO '+
                       ' WHERE NUMERO_PEDIDO = :NUMPED ';
         ParamByName('NUMPED').Value := numped;
         ExecSQL;
       end;

       Commit;
       Result:= True;
     except
       on E: Exception do
       begin
         ShowMessage('Erro: ' + E.Message );
         Rollback;
         Result:= false;
       end;
     end;
   end;
end;

function TPedido.Inserir: boolean;
begin
  with Conexao do
  begin
    with Qry do
    begin
      Close;
      sql.Clear;
      sql.Add(' SELECT MAX(NUMERO_PEDIDO) AS ULT FROM PEDIDO ');
      Open();
      FNumeroPedido:= FieldByName('ULT').AsInteger+1;
    end;

    try
      StartTransaction;

      with Qry do
      begin
        Close;
        sql.Clear;
        sql.Add(' INSERT INTO PEDIDO  '+
                        ' (NUMERO_PEDIDO,DATA_EMISSAO,CODIGO_CLIENTE,VALOR_TOTAL) VALUES '+
                        ' (:NUMERO_PEDIDO,:DATA_EMISSAO,:CODIGO_CLIENTE,:VALOR_TOTAL)');
        ParamByName('NUMERO_PEDIDO').Value  := FNumeroPedido;
        ParamByName('DATA_EMISSAO').Value   := FormatDateTime('yyyy-mm-dd',FDataEmissao);
        ParamByName('CODIGO_CLIENTE').Value := FCodigoCliente;
        ParamByName('VALOR_TOTAL').Value    := FValorTotal;
        ExecSQL;
      end;

      with Itens do
      begin
        if RecordCount > 0 then
        begin
          First;

          while not eof do
          begin
            with Qry do
            begin
              Close;
              sql.Clear;
              sql.Add(' INSERT INTO PEDIDO_PRODUTO  '+
                        ' (NUMERO_PEDIDO,CODIGO_PRODUTO,QUANTIDADE,VALOR_UNITARIO,VALOR_TOTAL) VALUES '+
                        ' (:NUMERO_PEDIDO,:CODIGO_PRODUTO,:QUANTIDADE,:VALOR_UNITARIO,:VALOR_TOTAL)');
              ParamByName('NUMERO_PEDIDO').Value  := FNumeroPedido;
              ParamByName('CODIGO_PRODUTO').Value := Itens.FieldByName('codigo_produto').AsVariant;
              ParamByName('QUANTIDADE').Value     := Itens.FieldByName('quantidade').AsVariant;
              ParamByName('VALOR_UNITARIO').Value := Itens.FieldByName('valor_unitario').AsVariant;
              ParamByName('VALOR_TOTAL').Value    := Itens.FieldByName('valor_total').AsVariant;
              ExecSQL;
            end;

            Next;
          end;
        end;
      end;
      result:= true;
      Commit;
    except
      on E: Exception do
      begin
        ShowMessage('Erro: ' + E.Message );
        Rollback;
        Result:= false;
      end;
    end;
  end;
end;

function TPedido.Selecionar(Numped: string): Boolean;
begin
  with Qry do
  begin
    Close;
    SQL.Clear;
    sql.Add('SELECT * FROM PEDIDO WHERE NUMERO_PEDIDO = '+ QuotedStr(Numped) );
    Open();

    if RecordCount > 0 then
    begin
      FDataEmissao   := FieldByName('DATA_EMISSAO').AsDateTime;
      FCodigoCliente := FieldByName('CODIGO_CLIENTE').AsInteger;
      FValorTotal    := FieldByName('VALOR_TOTAL').AsCurrency;

      with Qry do
      begin
        Close;
        SQL.Clear;
        sql.Add(' SELECT A.*,B.DESCRICAO FROM PEDIDO_PRODUTO A JOIN PRODUTOS B ON (B.CODIGO_PRODUTO = A.CODIGO_PRODUTO) WHERE NUMERO_PEDIDO = '+QuotedStr(Numped));
        Open();

        if RecordCount > 0 then
        begin
          First;

          while not eof do
          begin
            Itens.Insert;

            Itens.FieldByName('codigo_produto').AsVariant:= FieldByName('codigo_produto').AsVariant;
            Itens.FieldByName('quantidade').AsVariant    := FieldByName('quantidade').AsVariant;
            Itens.FieldByName('descricao').AsVariant     := FieldByName('descricao').AsVariant;
            Itens.FieldByName('valor_unitario').AsVariant:= FieldByName('valor_unitario').AsVariant;
            Itens.FieldByName('valor_total').AsVariant   := FieldByName('valor_total').AsVariant;

            Next;
          end;
        end;

      end;
      Result:= True;
    end
    else
      Result:= False;
  end;
end;

procedure TPedido.SetCodigoCliente(const Value: integer);
begin
  FCodigoCliente:= Value;
end;

procedure TPedido.SetDataEmissao(const Value: Tdate);
begin
  FDataEmissao:= Value;

end;

procedure TPedido.SetNumeroPedido(const Value: integer);
begin
  FNumeroPedido:= Value;
end;

procedure TPedido.SetQry(const Value: TFDQuery);
begin
  FQry:= Value;
end;


procedure TPedido.SetValorTotal(const Value: Currency);
begin
  FValorTotal:= Value;
end;

end.
