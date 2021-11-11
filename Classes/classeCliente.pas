
unit classeCliente;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait ,SysUtils, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type

  TCliente = class
    FCodigoCliente: integer;
    FNome         : string;
    FCidade       : String;
    FUF           : string;
    Conexao       : TFDConnection;
    FQry          : TFDQuery;

    procedure SetCodigoCliente(const Value: integer);
    procedure SetNome         (const Value: string);
    procedure SetCidade       (const Value: string);
    procedure SetUF           (const Value: string);
    procedure SetQry          (const Value: TFDQuery);

  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(Conn: TFDConnection);

    property CodigoCliente : integer  read FCodigoCliente write SetCodigoCliente;
    property Nome          : string   read FNome          write SetNome;
    property Cidade        : string   read FCidade        write SetCidade;
    property UF            : string   read FUF            write SetUF;
    property Qry           : TFDQuery read FQry           write SetQry;

    function Selecionar(CodigoCliente: Integer):Boolean;

  published
    { published declarations }

  end;

implementation

constructor TCliente.Create(Conn: TFDConnection);
begin
  Conexao         := Conn;
  Qry             := TFDQuery.Create(nil);
  Qry.Connection  := Conexao;
end;


function TCliente.Selecionar(CodigoCliente: Integer): Boolean;
begin
  with Qry do
  begin
    Close;
    Sql.Text := 'SELECT  * FROM CLIENTE WHERE CODIGO_CLIENTE = :CODIGO';
    ParamByName('CODIGO').Value:= CodigoCliente;

    try

      Open;

      FCodigoCliente := FieldByName('CODIGO_CLIENTE').AsInteger;
      FNome          := FieldByName('NOME').AsString;
      FCidade        := FieldByName('CIDADE').AsString;
      FUF            := FieldByName('UF').AsString;

      Result := RecordCount > 0;
    except
      Result := false;
    end;
  end;
end;

procedure TCliente.SetCidade(const Value: string);
begin
  FCidade:= Value;
end;

procedure TCliente.SetCodigoCliente(const Value: integer);
begin
  FCodigoCliente:= Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome:= Value;
end;

procedure TCliente.SetQry(const Value: TFDQuery);
begin
  FQry:= Value;
end;

procedure TCliente.SetUF(const Value: string);
begin
  FUF:= Value;
end;

end.
