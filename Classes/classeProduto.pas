unit classeProduto;


interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait ,SysUtils, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type

  TProduto = class
    FCodigoProduto : integer;
    FDescricao     : string;
    FPrecoVenda    : Double;
    Conexao        : TFDConnection;
    FQry           : TFDQuery;

    procedure SetCodigoProduto(const Value: integer);
    procedure SetDescricao    (const Value: string);
    procedure SetPrecoVenda   (const Value: Double);
    procedure SetQry          (const Value: TFDQuery);

  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create(Conn: TFDConnection);

    property CodigoProduto : integer  read FCodigoProduto write SetCodigoProduto;
    property Descricao     : string   read FDescricao     write SetDescricao;
    property PrecoVenda    : Double   read FPrecoVenda    write SetPrecoVenda;
    property Qry           : TFDQuery read FQry           write SetQry;

    function Selecionar(CodigoProduto: Integer):Boolean;

  published
    { published declarations }

  end;

implementation

constructor TProduto.Create(Conn: TFDConnection);
begin
  Conexao         := Conn;
  Qry             := TFDQuery.Create(nil);
  Qry.Connection  := Conexao;
end;


function TProduto.Selecionar(CodigoProduto: Integer): Boolean;
begin
  with Qry do
  begin
    Close;
    Sql.Text := ' Select * from produtos where codigo_produto = :Codigo ';
    ParamByName('Codigo').Value:= CodigoProduto;

    try

      Open;
      FCodigoProduto:= FieldByName('codigo_produto').AsInteger;
      FDescricao    := FieldByName('descricao').AsString;
      FPrecoVenda   := FieldByName('preco_venda').AsCurrency;

      Result := RecordCount > 0;
    except
      Result := false;
    end;
  end;
end;


procedure TProduto.SetCodigoProduto(const Value: integer);
begin
  FCodigoProduto:= Value;
end;

procedure TProduto.SetDescricao(const Value: string);
begin
  FDescricao:= Value;
end;

procedure TProduto.SetPrecoVenda(const Value: Double);
begin
  FPrecoVenda:= Value;
end;

procedure TProduto.SetQry(const Value: TFDQuery);
begin
  FQry:= Value;
end;

end.

