unit UntGrafoUtils;

interface

uses
  Classes, SysUtils, UntGraspModel;

function AlocarMatriz(AMatriz: TMatriz; ADimensao: integer): TMatriz;
procedure LerArquivoParaGrafo(var AGrafo: TMatriz; ACaminho: string);
procedure ImprimirGrafo(AGrafo: TMatriz);

implementation

function AlocarMatriz(AMatriz: TMatriz; ADimensao: integer): TMatriz;
var
  i: integer;
begin
  SetLength(AMatriz, ADimensao);
  for i := 0 to ADimensao - 1 do
  begin
    SetLength(AMatriz[i], ADimensao);
  end;
  Result := AMatriz;
end;

procedure LerArquivoParaGrafo(var AGrafo: TMatriz; ACaminho: string);
var
  dimensao: integer;
  custo: real;
  i, j: integer;
  Arquivo: TextFile;
begin
  try
    AssignFile(Arquivo, ACaminho);
{$I-}
    reset(Arquivo);
{$I+}
    if IOResult <> 0 then
    begin
      write('Entre com o caminho completo até o arquivo!');
    end;
    readln(Arquivo, dimensao);
    AGrafo := AlocarMatriz(AGrafo, dimensao);
    for i := 0 to dimensao - 1 do
    begin
      for j := 0 to dimensao - 1 do
      begin
        Read(Arquivo, custo);
        AGrafo[i][j] := custo;
      end;
      AGrafo[i][i] := 0;
    end;
  finally
    CloseFile(Arquivo);
  end;
end;

procedure ImprimirGrafo(AGrafo: TMatriz);
var
  i, j: integer;
begin
  for i := 0 to length(AGrafo) - 1 do
  begin
    for j := 0 to length(AGrafo) - 1 do
    begin
      Write(FloatTOstr(AGrafo[i][j]) + ' ');
    end;
    writeln;
  end;
end;

end.
