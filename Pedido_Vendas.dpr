program Pedido_Vendas;

uses
  Vcl.Forms,
  UntTelaPrincipal in 'Units\UntTelaPrincipal.pas' {FrmPrincipal},
  classeCliente in 'Classes\classeCliente.pas',
  classeProduto in 'Classes\classeProduto.pas',
  classePedido in 'Classes\classePedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
