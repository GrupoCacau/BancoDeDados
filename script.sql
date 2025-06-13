CREATE DATABASE MaisCacau_pi;
USE MaisCacau_pi; 


create table empresa(
idEmpresa int primary  key auto_increment,
nome varchar (100) not null,
cnpj char (14) not null unique,
telefone char (11) not null,
email varchar (80) not null,
cep char (8) not null,
numero varchar(10),
logradouro varchar(80),
bairro varchar (50),
estadoUF char (2) not null,
cidade varchar (80) not null,
complemento varchar(100),
codigoAtivacao char(6) not null
); 
 
 create table funcionario(
 idFuncionario int primary key auto_increment,
 nome varchar(45) not null,
 email varchar(45) not null,
 senha varchar(15) not null,
 fkEmpresa int,
 constraint fkEmpresa_funcionario foreign key(fkEmpresa) references empresa(idEmpresa)
 );
 
 
 create table fazenda (
 idFazenda int auto_increment,
 nome varchar(45),
 fkEmpresa int,
constraint fkFazendaEmpresa foreign key (fkEmpresa) references empresa(idEmpresa),
constraint pkCompostaFazenda primary key (idFazenda, fkEmpresa) 
 );
 
 create table hectares (
 idHectare int auto_increment,
 nomeHectare varchar(100),
 fkFazenda int, 
 constraint fkFazendaHectare foreign key (fkFazenda) references fazenda(idFazenda),
 constraint pkCompostaHectares primary key (idHectare, fkFazenda) 
);

create table setores (
idSetores int auto_increment,
nomeSetores varchar(45),
fkHectare int,
	constraint fkHectareSetor
    foreign key (fkHectare)
    references hectares(idHectare),
    constraint pkCompostaSetores
    primary key (idSetores, fkHectare)
);


create table sensores (
idSensor int auto_increment,
numSerie varchar (45) not null,
situacao varchar(20) not null,
fkSetores int,
fkHectare int,
	constraint fkSetores foreign key (fkSetores) references setores(idSetores),
constraint fkHectareSensores foreign key (fkHectare) references hectares(idHectare),
primary key (idSensor, fkSetores, fkHectare)
);




create table leitura(
idLeitura int auto_increment,
fkSensor int,
constraint pkComposta primary key(idLeitura, fkSensor),
umidade int not null,
dtRegistro datetime default current_timestamp,
constraint fk_leitura_sensor foreign key (fkSensor) references sensores(idSensor)
);


insert into empresa (nome,cnpj,telefone, email, cep, numero,logradouro,bairro, estadoUf, cidade, complemento, codigoAtivacao) values
('Cacau do Vale Agroindustrial Ltda', '12345678000195',  '11999998888',  'contato@techsolutions.com.br', 
 '04547000', '123',  'Av. das Nações Unidas', 'Brooklin', 'SP', 'São Paulo',   'Conjunto 42',  'ABC123'),
('Sementes de Ouro Cacau e Agricultura ME', '39847215000167', '11987654321', 'contato@globaltech.com.br', 
'04578903', '1001', 'Rua Funchal', 'Vila Olímpia', 'SP', 'São Paulo', '5º andar - Sala 502', 'GTX123'),
('Floresta Cacau e Produtos Naturais EIRELI', '04729166000122', '31988776655', 'vendas@ecolife.com.br', 
'30140071', '250', 'Av. do Contorno', 'Funcionários', 'MG', 'Belo Horizonte', 'Loja 01', 'ECO456');

SELECT * FROM sensores;
SELECT * FROM hectares;
SELECT * FROM setores;
SELECT * FROM sensores;
SELECT * FROM leitura;
SELECT * FROM empresa;
SELECT * FROM funcionario;

-- SELECT KPI 1
CREATE VIEW vw_kpis AS 
SELECT f.nome AS nomeFazenda, h.nomeHectare AS nomeHectares, se.nomeSetores AS nomeSetores, s.idSensor AS codSensor,  s.situacao AS situacaoSensor, l.umidade AS umidade, l.dtRegistro AS dataCaptura, fkEmpresa AS fkEmpresa FROM leitura AS l
	JOIN sensores AS s
		ON l.fkSensor = s.idSensor
	JOIN setores AS se
		ON s.fkSetores = se.idSetores
	JOIN hectares AS h
		ON se.fkHectare = h.idHectare
	JOIN fazenda AS f
		ON h.fkFazenda = f.idFazenda
	GROUP BY f.nome, h.nomeHectare, se.nomeSetores, s.idSensor,  s.situacao, l.umidade, l.dtRegistro, fkEmpresa; 

SELECT * FROM vw_kpis;

    -- 1) Cria uma fazenda vinculada à empresa de idEmpresa = 1
INSERT INTO fazenda (nome, fkEmpresa)
VALUES ('Recanto do Sol', 1);

-- 2) Insere 10 hectares para essa fazenda (fkFazenda = 1)
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 1', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 2', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 3', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 4', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 5', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 6', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 7', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 8', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 9', 1);
INSERT INTO hectares (nomeHectare, fkFazenda) VALUES ('Hectare 10', 1);

-- 3) Para cada hectare (1 a 10), insere 10 setores.
--    Aqui idSetores vai auto‐incrementar de 1 até 100 ao total,
--    mas o fkHectare permanece correspondente (1–10).
--    Exemplos de nomeSensor: 'Setor <hectare>-<índice dentro do hectare>'

-- Setores do Hectare 1
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-1', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-2', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-3', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-4', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-5', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-6', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-7', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-8', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-9', 1);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 1-10', 1);

-- Setores do Hectare 2
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-1', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-2', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-3', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-4', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-5', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-6', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-7', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-8', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-9', 2);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 2-10', 2);

-- Setores do Hectare 3
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-1', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-2', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-3', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-4', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-5', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-6', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-7', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-8', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-9', 3);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 3-10', 3);

-- Setores do Hectare 4
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-1', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-2', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-3', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-4', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-5', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-6', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-7', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-8', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-9', 4);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 4-10', 4);

-- Setores do Hectare 5
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-1', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-2', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-3', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-4', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-5', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-6', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-7', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-8', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-9', 5);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 5-10', 5);

-- Setores do Hectare 6
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-1', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-2', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-3', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-4', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-5', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-6', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-7', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-8', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-9', 6);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 6-10', 6);

-- Setores do Hectare 7
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-1', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-2', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-3', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-4', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-5', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-6', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-7', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-8', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-9', 7);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 7-10', 7);

-- Setores do Hectare 8
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-1', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-2', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-3', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-4', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-5', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-6', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-7', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-8', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-9', 8);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 8-10', 8);

-- Setores do Hectare 9
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-1', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-2', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-3', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-4', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-5', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-6', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-7', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-8', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-9', 9);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 9-10', 9);

-- Setores do Hectare 10
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-1', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-2', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-3', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-4', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-5', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-6', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-7', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-8', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-9', 10);
INSERT INTO setores (nomeSetores, fkHectare) VALUES ('Setor 10-10', 10);

-- 4) Insere 2 sensores para cada setor (total de 100 setores → 200 sensores).
--    Pressupõe-se que idSetores gerados sequencialmente de 1 a 100:
--    setores 1–10 → fkHectare = 1,
--    setores 11–20 → fkHectare = 2, e assim por diante…

-- Sensores nos 10 primeiros setores (hectare = 1)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S1-1', 'Ativo',  1, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S1-2', 'Ativo',  1, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S2-1', 'Ativo',  2, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S2-2', 'Ativo',  2, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S3-1', 'Ativo',  3, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S3-2', 'Ativo',  3, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S4-1', 'Ativo',  4, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S4-2', 'Ativo',  4, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S5-1', 'Ativo',  5, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S5-2', 'Ativo',  5, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S6-1', 'Ativo',  6, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S6-2', 'Ativo',  6, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S7-1', 'Ativo',  7, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S7-2', 'Ativo',  7, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S8-1', 'Ativo',  8, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S8-2', 'Ativo',  8, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S9-1', 'Ativo',  9, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S9-2', 'Ativo',  9, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S10-1','Ativo', 10, 1);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S10-2','Ativo', 10, 1);

-- Sensores nos setores 11–20 (hectare = 2)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S11-1', 'Ativo', 11, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S11-2', 'Ativo', 11, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S12-1', 'Ativo', 12, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S12-2', 'Ativo', 12, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S13-1', 'Ativo', 13, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S13-2', 'Ativo', 13, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S14-1', 'Ativo', 14, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S14-2', 'Ativo', 14, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S15-1', 'Ativo', 15, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S15-2', 'Ativo', 15, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S16-1', 'Ativo', 16, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S16-2', 'Ativo', 16, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S17-1', 'Ativo', 17, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S17-2', 'Ativo', 17, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S18-1', 'Ativo', 18, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S18-2', 'Ativo', 18, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S19-1', 'Ativo', 19, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S19-2', 'Ativo', 19, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S20-1','Ativo', 20, 2);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S20-2','Ativo', 20, 2);

-- Sensores nos setores 21–30 (hectare = 3)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S21-1', 'Ativo', 21, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S21-2', 'Ativo', 21, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S22-1', 'Ativo', 22, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S22-2', 'Ativo', 22, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S23-1', 'Ativo', 23, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S23-2', 'Ativo', 23, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S24-1', 'Ativo', 24, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S24-2', 'Ativo', 24, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S25-1', 'Ativo', 25, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S25-2', 'Ativo', 25, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S26-1', 'Ativo', 26, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S26-2', 'Ativo', 26, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S27-1', 'Ativo', 27, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S27-2', 'Ativo', 27, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S28-1', 'Ativo', 28, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S28-2', 'Ativo', 28, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S29-1', 'Ativo', 29, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S29-2', 'Ativo', 29, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S30-1','Ativo', 30, 3);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S30-2','Ativo', 30, 3);

-- Sensores nos setores 31–40 (hectare = 4)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S31-1', 'Ativo', 31, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S31-2', 'Ativo', 31, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S32-1', 'Ativo', 32, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S32-2', 'Ativo', 32, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S33-1', 'Ativo', 33, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S33-2', 'Ativo', 33, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S34-1', 'Ativo', 34, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S34-2', 'Ativo', 34, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S35-1', 'Ativo', 35, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S35-2', 'Ativo', 35, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S36-1', 'Ativo', 36, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S36-2', 'Ativo', 36, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S37-1', 'Ativo', 37, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S37-2', 'Ativo', 37, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S38-1', 'Ativo', 38, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S38-2', 'Ativo', 38, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S39-1', 'Ativo', 39, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S39-2', 'Ativo', 39, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S40-1','Ativo', 40, 4);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S40-2','Ativo', 40, 4);

-- Sensores nos setores 41–50 (hectare = 5)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S41-1', 'Ativo', 41, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S41-2', 'Ativo', 41, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S42-1', 'Ativo', 42, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S42-2', 'Ativo', 42, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S43-1', 'Ativo', 43, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S43-2', 'Ativo', 43, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S44-1', 'Ativo', 44, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S44-2', 'Ativo', 44, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S45-1', 'Ativo', 45, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S45-2', 'Ativo', 45, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S46-1', 'Ativo', 46, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S46-2', 'Ativo', 46, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S47-1', 'Ativo', 47, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S47-2', 'Ativo', 47, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S48-1', 'Ativo', 48, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S48-2', 'Ativo', 48, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S49-1', 'Ativo', 49, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S49-2', 'Ativo', 49, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S50-1','Ativo', 50, 5);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S50-2','Ativo', 50, 5);

-- Sensores nos setores 51–60 (hectare = 6)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S51-1', 'Ativo', 51, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S51-2', 'Ativo', 51, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S52-1', 'Ativo', 52, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S52-2', 'Ativo', 52, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S53-1', 'Ativo', 53, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S53-2', 'Ativo', 53, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S54-1', 'Ativo', 54, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S54-2', 'Ativo', 54, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S55-1', 'Ativo', 55, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S55-2', 'Ativo', 55, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S56-1', 'Ativo', 56, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S56-2', 'Ativo', 56, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S57-1', 'Ativo', 57, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S57-2', 'Ativo', 57, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S58-1', 'Ativo', 58, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S58-2', 'Ativo', 58, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S59-1', 'Ativo', 59, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S59-2', 'Ativo', 59, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S60-1','Ativo', 60, 6);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S60-2','Ativo', 60, 6);

-- Sensores nos setores 61–70 (hectare = 7)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S61-1', 'Ativo', 61, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S61-2', 'Ativo', 61, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S62-1', 'Ativo', 62, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S62-2', 'Ativo', 62, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S63-1', 'Ativo', 63, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S63-2', 'Ativo', 63, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S64-1', 'Ativo', 64, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S64-2', 'Ativo', 64, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S65-1', 'Ativo', 65, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S65-2', 'Ativo', 65, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S66-1', 'Ativo', 66, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S66-2', 'Ativo', 66, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S67-1', 'Ativo', 67, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S67-2', 'Ativo', 67, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S68-1', 'Ativo', 68, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S68-2', 'Ativo', 68, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S69-1', 'Ativo', 69, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S69-2', 'Ativo', 69, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S70-1','Ativo', 70, 7);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S70-2','Ativo', 70, 7);

-- Sensores nos setores 71–80 (hectare = 8)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S71-1', 'Ativo', 71, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S71-2', 'Ativo', 71, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S72-1', 'Ativo', 72, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S72-2', 'Ativo', 72, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S73-1', 'Ativo', 73, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S73-2', 'Ativo', 73, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S74-1', 'Ativo', 74, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S74-2', 'Ativo', 74, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S75-1', 'Ativo', 75, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S75-2', 'Ativo', 75, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S76-1', 'Ativo', 76, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S76-2', 'Ativo', 76, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S77-1', 'Ativo', 77, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S77-2', 'Ativo', 77, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S78-1', 'Ativo', 78, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S78-2', 'Ativo', 78, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S79-1', 'Ativo', 79, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S79-2', 'Ativo', 79, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S80-1','Ativo', 80, 8);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S80-2','Ativo', 80, 8);

-- Sensores nos setores 81–90 (hectare = 9)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S81-1', 'Ativo', 81, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S81-2', 'Ativo', 81, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S82-1', 'Ativo', 82, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S82-2', 'Ativo', 82, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S83-1', 'Ativo', 83, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S83-2', 'Ativo', 83, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S84-1', 'Ativo', 84, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S84-2', 'Ativo', 84, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S85-1', 'Ativo', 85, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S85-2', 'Ativo', 85, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S86-1', 'Ativo', 86, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S86-2', 'Ativo', 86, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S87-1', 'Ativo', 87, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S87-2', 'Ativo', 87, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S88-1', 'Ativo', 88, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S88-2', 'Ativo', 88, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S89-1', 'Ativo', 89, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S89-2', 'Ativo', 89, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S90-1','Ativo', 90, 9);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S90-2','Ativo', 90, 9);

-- Sensores nos setores 91–100 (hectare = 10)
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S91-1', 'Ativo', 91, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S91-2', 'Ativo', 91, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S92-1', 'Ativo', 92, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S92-2', 'Ativo', 92, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S93-1', 'Ativo', 93, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S93-2', 'Ativo', 93, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S94-1', 'Ativo', 94, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S94-2', 'Ativo', 94, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S95-1', 'Ativo', 95, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S95-2', 'Ativo', 95, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S96-1', 'Ativo', 96, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S96-2', 'Ativo', 96, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S97-1', 'Ativo', 97, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S97-2', 'Ativo', 97, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S98-1', 'Ativo', 98, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S98-2', 'Ativo', 98, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S99-1', 'Ativo', 99, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S99-2', 'Ativo', 99, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S100-1','Ativo',100, 10);
INSERT INTO sensores (numSerie, situacao, fkSetores, fkHectare) VALUES ('S100-2','Ativo',100, 10);

-- 5) Insere 2 leituras para cada um dos 200 sensores.
--    A umidade média (entre as 2 leituras iguais) varia de 55 a 85.
--    Calcula-se humid[i] = 55 + FLOOR((i-1)*30 / 199), para sensor i = 1..200.
--    Em cada sensor, insere duas linhas com o mesmo valor, garantindo que a média seja exatamente esse valor.

INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (1, 56, '2025-06-06 12:45:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (1, 55, '2025-06-07 11:59:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (2, 55, '2025-06-04 06:41:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (2, 56, '2025-06-01 04:10:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (3, 56, '2025-06-03 06:46:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (3, 55, '2025-06-05 04:10:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (4, 55, '2025-06-05 14:52:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (4, 56, '2025-06-01 02:09:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (5, 56, '2025-06-01 22:25:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (5, 55, '2025-06-02 12:54:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (6, 55, '2025-06-06 02:41:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (6, 56, '2025-06-07 19:14:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (7, 56, '2025-06-04 05:39:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (7, 55, '2025-06-02 02:12:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (8, 55, '2025-06-07 05:32:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (8, 56, '2025-06-06 03:38:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (9, 56, '2025-06-06 17:53:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (9, 55, '2025-06-01 19:20:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (10, 55, '2025-06-03 20:09:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (10, 56, '2025-06-05 16:19:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (11, 56, '2025-06-04 18:55:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (11, 55, '2025-06-04 13:42:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (12, 55, '2025-06-03 17:26:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (12, 56, '2025-06-06 01:57:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (13, 56, '2025-06-06 16:33:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (13, 55, '2025-06-07 10:21:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (14, 55, '2025-06-05 01:51:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (14, 56, '2025-06-04 16:42:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (15, 56, '2025-06-02 22:52:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (15, 55, '2025-06-06 02:34:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (16, 55, '2025-06-07 17:12:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (16, 56, '2025-06-07 04:58:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (17, 56, '2025-06-02 23:16:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (17, 55, '2025-06-02 13:17:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (18, 55, '2025-06-06 13:57:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (18, 56, '2025-06-05 19:17:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (19, 56, '2025-06-05 16:59:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (19, 55, '2025-06-02 13:42:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (20, 55, '2025-06-05 19:13:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (20, 56, '2025-06-04 21:05:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (21, 56, '2025-06-05 12:18:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (21, 55, '2025-06-04 16:33:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (22, 55, '2025-06-05 18:24:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (22, 56, '2025-06-03 03:24:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (23, 56, '2025-06-03 22:29:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (23, 55, '2025-06-03 03:25:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (24, 55, '2025-06-06 08:01:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (24, 56, '2025-06-06 02:50:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (25, 56, '2025-06-03 02:29:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (25, 55, '2025-06-06 09:01:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (26, 55, '2025-06-06 05:23:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (26, 56, '2025-06-03 03:06:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (27, 56, '2025-06-05 10:25:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (27, 55, '2025-06-04 00:06:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (28, 55, '2025-06-02 11:18:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (28, 56, '2025-06-07 19:45:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (29, 56, '2025-06-01 11:26:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (29, 55, '2025-06-02 05:07:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (30, 55, '2025-06-04 21:50:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (30, 56, '2025-06-02 06:18:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (31, 56, '2025-06-03 21:11:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (31, 55, '2025-06-03 21:26:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (32, 55, '2025-06-05 00:19:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (32, 56, '2025-06-02 01:16:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (33, 56, '2025-06-04 21:04:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (33, 55, '2025-06-04 05:52:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (34, 55, '2025-06-04 11:55:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (34, 56, '2025-06-06 10:31:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (35, 56, '2025-06-06 01:21:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (35, 55, '2025-06-05 01:54:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (36, 55, '2025-06-04 09:08:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (36, 56, '2025-06-07 09:21:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (37, 56, '2025-06-03 17:01:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (37, 55, '2025-06-06 10:09:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (38, 55, '2025-06-03 08:16:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (38, 56, '2025-06-06 07:21:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (39, 56, '2025-06-07 12:09:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (39, 55, '2025-06-03 16:11:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (40, 55, '2025-06-01 07:07:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (40, 56, '2025-06-03 21:35:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (41, 56, '2025-06-03 12:01:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (41, 55, '2025-06-05 23:23:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (42, 55, '2025-06-01 17:06:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (42, 56, '2025-06-02 02:36:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (43, 56, '2025-06-02 05:34:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (43, 55, '2025-06-01 14:16:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (44, 55, '2025-06-02 07:42:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (44, 56, '2025-06-06 06:46:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (45, 56, '2025-06-05 12:34:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (45, 55, '2025-06-06 04:36:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (46, 55, '2025-06-07 15:31:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (46, 56, '2025-06-07 11:25:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (47, 56, '2025-06-02 07:56:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (47, 55, '2025-06-05 14:07:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (48, 55, '2025-06-03 02:56:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (48, 56, '2025-06-03 18:24:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (49, 56, '2025-06-07 20:17:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (49, 55, '2025-06-06 14:06:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (50, 55, '2025-06-04 14:41:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (50, 56, '2025-06-03 08:07:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (51, 56, '2025-06-01 08:30:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (51, 55, '2025-06-02 09:18:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (52, 55, '2025-06-04 05:37:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (52, 56, '2025-06-05 22:18:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (53, 56, '2025-06-05 13:35:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (53, 55, '2025-06-06 07:12:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (54, 55, '2025-06-05 19:15:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (54, 56, '2025-06-07 12:11:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (55, 56, '2025-06-01 22:17:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (55, 55, '2025-06-06 09:03:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (56, 55, '2025-06-04 15:55:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (56, 56, '2025-06-03 19:48:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (57, 56, '2025-06-04 04:33:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (57, 55, '2025-06-07 10:01:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (58, 55, '2025-06-02 07:09:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (58, 56, '2025-06-07 20:06:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (59, 56, '2025-06-04 12:57:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (59, 55, '2025-06-06 19:45:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (60, 55, '2025-06-02 06:53:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (60, 56, '2025-06-06 13:51:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (61, 56, '2025-06-05 16:09:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (61, 55, '2025-06-07 16:17:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (62, 55, '2025-06-02 22:24:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (62, 56, '2025-06-07 14:57:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (63, 56, '2025-06-04 05:11:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (63, 55, '2025-06-04 05:13:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (64, 55, '2025-06-04 12:38:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (64, 56, '2025-06-03 18:38:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (65, 56, '2025-06-01 21:46:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (65, 55, '2025-06-05 14:12:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (66, 55, '2025-06-01 13:05:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (66, 56, '2025-06-01 10:44:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (67, 56, '2025-06-02 20:05:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (67, 55, '2025-06-07 03:03:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (68, 55, '2025-06-03 02:57:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (68, 56, '2025-06-02 07:36:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (69, 56, '2025-06-01 10:30:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (69, 55, '2025-06-07 16:15:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (70, 55, '2025-06-02 12:43:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (70, 56, '2025-06-04 07:58:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (71, 56, '2025-06-03 17:59:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (71, 55, '2025-06-07 22:16:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (72, 55, '2025-06-01 19:48:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (72, 56, '2025-06-06 12:19:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (73, 56, '2025-06-07 01:21:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (73, 55, '2025-06-05 18:20:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (74, 55, '2025-06-05 01:28:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (74, 56, '2025-06-04 12:18:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (75, 56, '2025-06-07 08:49:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (75, 55, '2025-06-06 13:32:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (76, 55, '2025-06-03 15:29:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (76, 56, '2025-06-04 17:08:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (77, 56, '2025-06-01 11:55:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (77, 55, '2025-06-04 09:27:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (78, 55, '2025-06-03 10:30:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (78, 56, '2025-06-06 16:34:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (79, 56, '2025-06-01 01:14:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (79, 55, '2025-06-05 13:58:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (80, 55, '2025-06-06 07:43:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (80, 56, '2025-06-01 09:54:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (81, 56, '2025-06-05 23:50:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (81, 55, '2025-06-07 05:50:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (82, 55, '2025-06-05 07:11:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (82, 56, '2025-06-07 00:37:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (83, 56, '2025-06-03 05:32:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (83, 55, '2025-06-03 16:59:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (84, 55, '2025-06-05 21:58:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (84, 56, '2025-06-04 07:21:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (85, 56, '2025-06-06 01:47:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (85, 55, '2025-06-02 15:46:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (86, 55, '2025-06-03 03:17:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (86, 56, '2025-06-02 02:07:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (87, 56, '2025-06-02 10:30:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (87, 55, '2025-06-03 12:50:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (88, 55, '2025-06-03 22:16:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (88, 56, '2025-06-07 05:57:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (89, 56, '2025-06-01 21:54:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (89, 55, '2025-06-04 22:09:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (90, 55, '2025-06-01 12:58:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (90, 56, '2025-06-01 16:50:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (91, 56, '2025-06-05 05:18:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (91, 55, '2025-06-05 01:12:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (92, 55, '2025-06-03 08:30:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (92, 56, '2025-06-04 18:37:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (93, 56, '2025-06-07 23:51:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (93, 55, '2025-06-01 23:45:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (94, 55, '2025-06-04 05:58:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (94, 56, '2025-06-07 23:45:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (95, 56, '2025-06-03 09:57:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (95, 55, '2025-06-06 04:31:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (96, 55, '2025-06-05 21:15:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (96, 56, '2025-06-04 18:48:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (97, 56, '2025-06-03 03:19:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (97, 55, '2025-06-01 17:44:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (98, 55, '2025-06-07 07:56:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (98, 56, '2025-06-03 13:39:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (99, 56, '2025-06-07 15:01:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (99, 55, '2025-06-03 05:08:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (100, 55, '2025-06-05 01:51:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (100, 56, '2025-06-04 00:11:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (101, 56, '2025-06-07 11:55:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (101, 55, '2025-06-04 12:47:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (102, 55, '2025-06-04 01:13:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (102, 56, '2025-06-07 05:05:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (103, 56, '2025-06-06 17:06:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (103, 55, '2025-06-07 16:05:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (104, 55, '2025-06-07 06:14:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (104, 56, '2025-06-06 11:46:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (105, 56, '2025-06-03 20:22:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (105, 55, '2025-06-05 18:00:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (106, 55, '2025-06-05 02:30:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (106, 56, '2025-06-02 11:30:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (107, 56, '2025-06-03 12:48:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (107, 55, '2025-06-03 17:45:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (108, 55, '2025-06-01 03:46:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (108, 56, '2025-06-05 13:01:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (109, 56, '2025-06-01 08:13:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (109, 55, '2025-06-07 16:50:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (110, 55, '2025-06-04 06:16:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (110, 56, '2025-06-04 17:57:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (111, 56, '2025-06-05 13:19:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (111, 55, '2025-06-07 07:06:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (112, 55, '2025-06-07 06:06:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (112, 56, '2025-06-03 15:47:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (113, 56, '2025-06-01 22:57:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (113, 55, '2025-06-03 20:40:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (114, 55, '2025-06-04 20:02:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (114, 56, '2025-06-02 02:27:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (115, 56, '2025-06-02 17:48:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (115, 55, '2025-06-07 13:27:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (116, 55, '2025-06-05 19:03:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (116, 56, '2025-06-07 22:01:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (117, 56, '2025-06-04 01:26:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (117, 55, '2025-06-06 21:06:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (118, 55, '2025-06-02 15:56:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (118, 56, '2025-06-05 20:29:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (119, 56, '2025-06-03 05:54:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (119, 55, '2025-06-02 01:59:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (120, 55, '2025-06-05 03:59:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (120, 56, '2025-06-06 03:54:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (121, 56, '2025-06-01 15:26:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (121, 55, '2025-06-01 23:53:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (122, 55, '2025-06-03 10:51:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (122, 56, '2025-06-03 03:30:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (123, 56, '2025-06-05 05:59:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (123, 55, '2025-06-01 06:20:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (124, 55, '2025-06-01 10:16:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (124, 56, '2025-06-02 09:50:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (125, 56, '2025-06-06 06:08:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (125, 55, '2025-06-06 09:27:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (126, 55, '2025-06-07 05:30:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (126, 56, '2025-06-06 10:05:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (127, 56, '2025-06-04 02:46:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (127, 55, '2025-06-04 00:40:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (128, 55, '2025-06-04 17:01:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (128, 56, '2025-06-01 00:49:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (129, 56, '2025-06-04 06:14:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (129, 55, '2025-06-03 21:43:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (130, 55, '2025-06-04 13:43:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (130, 56, '2025-06-05 04:43:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (131, 56, '2025-06-04 00:27:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (131, 55, '2025-06-04 23:57:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (132, 55, '2025-06-02 09:50:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (132, 56, '2025-06-02 20:30:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (133, 56, '2025-06-01 22:07:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (133, 55, '2025-06-03 08:12:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (134, 55, '2025-06-07 01:23:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (134, 56, '2025-06-04 14:16:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (135, 56, '2025-06-06 02:40:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (135, 55, '2025-06-01 21:06:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (136, 55, '2025-06-05 13:06:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (136, 56, '2025-06-05 16:03:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (137, 56, '2025-06-01 03:30:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (137, 55, '2025-06-06 00:04:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (138, 55, '2025-06-06 21:25:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (138, 56, '2025-06-01 15:47:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (139, 56, '2025-06-01 16:05:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (139, 55, '2025-06-01 09:11:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (140, 55, '2025-06-04 05:09:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (140, 56, '2025-06-04 11:35:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (141, 56, '2025-06-03 08:58:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (141, 55, '2025-06-05 09:48:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (142, 55, '2025-06-04 08:40:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (142, 56, '2025-06-06 01:18:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (143, 56, '2025-06-06 19:28:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (143, 55, '2025-06-05 19:38:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (144, 55, '2025-06-06 20:20:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (144, 56, '2025-06-01 13:40:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (145, 56, '2025-06-02 12:27:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (145, 55, '2025-06-05 18:27:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (146, 55, '2025-06-04 16:21:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (146, 56, '2025-06-06 02:08:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (147, 56, '2025-06-04 18:09:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (147, 55, '2025-06-04 10:41:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (148, 55, '2025-06-06 09:06:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (148, 56, '2025-06-06 04:05:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (149, 56, '2025-06-03 01:58:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (149, 55, '2025-06-05 06:45:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (150, 55, '2025-06-05 05:35:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (150, 56, '2025-06-05 02:05:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (151, 56, '2025-06-01 17:05:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (151, 55, '2025-06-04 10:01:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (152, 55, '2025-06-01 12:58:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (152, 56, '2025-06-02 19:40:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (153, 56, '2025-06-01 07:43:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (153, 55, '2025-06-05 11:54:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (154, 55, '2025-06-03 06:45:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (154, 56, '2025-06-01 15:36:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (155, 56, '2025-06-05 09:05:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (155, 55, '2025-06-07 23:22:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (156, 55, '2025-06-07 17:23:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (156, 56, '2025-06-02 07:13:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (157, 56, '2025-06-02 04:03:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (157, 55, '2025-06-02 02:33:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (158, 55, '2025-06-01 00:45:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (158, 56, '2025-06-01 14:01:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (159, 56, '2025-06-02 23:37:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (159, 55, '2025-06-03 22:53:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (160, 55, '2025-06-01 22:38:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (160, 56, '2025-06-02 15:55:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (161, 56, '2025-06-03 19:58:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (161, 55, '2025-06-04 01:46:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (162, 55, '2025-06-03 06:19:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (162, 56, '2025-06-02 10:42:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (163, 56, '2025-06-01 10:58:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (163, 55, '2025-06-02 16:18:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (164, 55, '2025-06-06 21:41:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (164, 56, '2025-06-04 19:20:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (165, 56, '2025-06-05 15:22:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (165, 55, '2025-06-01 05:30:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (166, 55, '2025-06-05 11:53:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (166, 56, '2025-06-03 08:03:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (167, 56, '2025-06-01 19:00:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (167, 55, '2025-06-05 12:59:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (168, 55, '2025-06-01 06:00:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (168, 56, '2025-06-03 20:32:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (169, 56, '2025-06-04 01:18:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (169, 55, '2025-06-04 10:56:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (170, 55, '2025-06-02 20:21:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (170, 56, '2025-06-07 23:28:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (171, 56, '2025-06-01 00:31:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (171, 55, '2025-06-01 07:12:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (172, 55, '2025-06-02 20:18:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (172, 56, '2025-06-03 13:38:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 56, '2025-06-05 19:06:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 55, '2025-06-04 12:05:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 55, '2025-06-04 12:05:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (174, 55, '2025-06-04 20:44:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (174, 56, '2025-06-03 12:55:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (175, 56, '2025-06-01 17:55:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (175, 55, '2025-06-07 11:26:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (176, 55, '2025-06-05 04:40:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (176, 56, '2025-06-02 21:11:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (177, 56, '2025-06-04 14:04:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (177, 55, '2025-06-03 22:24:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (178, 55, '2025-06-05 10:14:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (178, 56, '2025-06-04 08:10:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (179, 56, '2025-06-02 09:24:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (179, 55, '2025-06-05 07:32:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (180, 55, '2025-06-07 18:23:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (180, 56, '2025-06-03 14:39:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (181, 56, '2025-06-01 01:12:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (181, 55, '2025-06-03 11:03:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (182, 55, '2025-06-02 01:41:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (182, 56, '2025-06-02 11:09:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (183, 56, '2025-06-07 18:30:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (183, 55, '2025-06-01 21:42:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (184, 55, '2025-06-06 20:42:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (184, 56, '2025-06-04 18:35:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (185, 56, '2025-06-06 01:13:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (185, 55, '2025-06-06 05:18:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (186, 55, '2025-06-01 15:09:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (186, 56, '2025-06-01 22:53:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (187, 56, '2025-06-06 21:19:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (187, 55, '2025-06-01 09:13:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (188, 55, '2025-06-02 23:37:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (188, 56, '2025-06-05 14:04:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (189, 56, '2025-06-06 16:02:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (189, 55, '2025-06-04 04:48:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (190, 55, '2025-06-07 07:36:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (190, 56, '2025-06-03 22:59:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (191, 56, '2025-06-05 21:35:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (191, 55, '2025-06-05 21:53:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (192, 55, '2025-06-01 00:53:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (192, 56, '2025-06-01 13:25:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (193, 56, '2025-06-07 05:50:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (193, 55, '2025-06-05 13:47:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (194, 55, '2025-06-04 02:09:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (194, 56, '2025-06-03 22:42:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (195, 56, '2025-06-04 04:03:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (195, 55, '2025-06-02 19:51:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (196, 55, '2025-06-03 02:53:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (196, 56, '2025-06-01 04:34:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (197, 56, '2025-06-07 08:32:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (197, 55, '2025-06-05 02:57:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (198, 55, '2025-06-04 06:08:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (198, 56, '2025-06-05 02:08:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (199, 56, '2025-06-07 10:32:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (199, 55, '2025-06-07 16:41:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (200, 55, '2025-06-02 00:50:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (200, 56, '2025-06-02 03:29:27');

-- 
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (1, 56, '2025-06-12 12:45:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (1, 55, '2025-06-12 11:59:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (2, 55, '2025-06-12 06:41:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (2, 56, '2025-06-12 04:10:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (3, 56, '2025-06-12 06:46:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (3, 55, '2025-06-12 04:10:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (4, 55, '2025-06-12 14:52:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (4, 56, '2025-06-12 02:09:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (5, 56, '2025-06-12 22:25:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (5, 55, '2025-06-12 12:54:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (6, 55, '2025-06-12 02:41:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (6, 56, '2025-06-12 19:14:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (7, 56, '2025-06-12 05:39:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (7, 55, '2025-06-12 02:12:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (8, 55, '2025-06-12 05:32:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (8, 56, '2025-06-12 03:38:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (9, 56, '2025-06-12 17:53:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (9, 55, '2025-06-12 19:20:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (10, 55, '2025-06-12 20:09:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (10, 56, '2025-06-12 16:19:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (11, 56, '2025-06-12 18:55:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (11, 55, '2025-06-12 13:42:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (12, 55, '2025-06-12 17:26:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (12, 56, '2025-06-12 01:57:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (13, 56, '2025-06-12 16:33:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (13, 55, '2025-06-12 10:21:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (14, 55, '2025-06-12 01:51:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (14, 56, '2025-06-12 16:42:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (15, 56, '2025-06-12 22:52:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (15, 55, '2025-06-12 02:34:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (16, 55, '2025-06-12 17:12:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (16, 56, '2025-06-12 04:58:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (17, 56, '2025-06-12 23:16:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (17, 55, '2025-06-12 13:17:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (18, 55, '2025-06-12 13:57:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (18, 56, '2025-06-12 19:17:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (19, 56, '2025-06-12 16:59:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (19, 55, '2025-06-12 13:42:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (20, 55, '2025-06-12 19:13:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (20, 56, '2025-06-12 21:05:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (21, 56, '2025-06-12 12:18:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (21, 55, '2025-06-12 16:33:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (22, 55, '2025-06-12 18:24:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (22, 56, '2025-06-12 03:24:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (23, 56, '2025-06-12 22:29:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (23, 55, '2025-06-12 03:25:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (24, 55, '2025-06-12 08:01:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (24, 56, '2025-06-12 02:50:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (25, 56, '2025-06-12 02:29:42');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (25, 55, '2025-06-12 09:01:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (26, 55, '2025-06-12 05:23:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (26, 56, '2025-06-12 03:06:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (27, 56, '2025-06-12 10:25:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (27, 55, '2025-06-12 00:06:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (28, 55, '2025-06-12 11:18:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (28, 56, '2025-06-12 19:45:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (29, 56, '2025-06-12 11:26:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (29, 55, '2025-06-12 05:07:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (30, 55, '2025-06-12 21:50:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (30, 56, '2025-06-12 06:18:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (31, 56, '2025-06-12 21:11:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (31, 55, '2025-06-12 21:26:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (32, 55, '2025-06-12 00:19:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (32, 56, '2025-06-12 01:16:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (33, 56, '2025-06-12 21:04:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (33, 55, '2025-06-12 05:52:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (34, 55, '2025-06-12 11:55:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (34, 56, '2025-06-12 10:31:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (35, 56, '2025-06-12 01:21:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (35, 55, '2025-06-12 01:54:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (36, 55, '2025-06-12 09:08:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (36, 56, '2025-06-12 09:21:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (37, 56, '2025-06-12 17:01:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (37, 55, '2025-06-12 10:09:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (38, 55, '2025-06-12 08:16:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (38, 56, '2025-06-12 07:21:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (39, 56, '2025-06-12 12:09:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (39, 55, '2025-06-12 16:11:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (40, 55, '2025-06-12 07:07:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (40, 56, '2025-06-12 21:35:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (41, 56, '2025-06-12 12:01:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (41, 55, '2025-06-12 23:23:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (42, 55, '2025-06-12 17:06:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (42, 56, '2025-06-12 02:36:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (43, 56, '2025-06-12 05:34:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (43, 55, '2025-06-12 14:16:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (44, 55, '2025-06-12 07:42:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (44, 56, '2025-06-12 06:46:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (45, 56, '2025-06-12 12:34:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (45, 55, '2025-06-12 04:36:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (46, 55, '2025-06-12 15:31:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (46, 56, '2025-06-12 11:25:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (47, 56, '2025-06-12 07:56:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (47, 55, '2025-06-12 14:07:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (48, 55, '2025-06-12 02:56:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (48, 56, '2025-06-12 18:24:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (49, 56, '2025-06-12 20:17:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (49, 55, '2025-06-12 14:06:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (50, 55, '2025-06-12 14:41:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (50, 56, '2025-06-12 08:07:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (51, 56, '2025-06-12 08:30:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (51, 55, '2025-06-12 09:18:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (52, 55, '2025-06-12 05:37:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (52, 56, '2025-06-12 22:18:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (53, 56, '2025-06-12 13:35:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (53, 55, '2025-06-12 07:12:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (54, 55, '2025-06-12 19:15:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (54, 56, '2025-06-12 12:11:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (55, 56, '2025-06-12 22:17:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (55, 55, '2025-06-12 09:03:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (56, 55, '2025-06-12 15:55:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (56, 56, '2025-06-12 19:48:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (57, 56, '2025-06-12 04:33:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (57, 55, '2025-06-12 10:01:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (58, 55, '2025-06-12 07:09:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (58, 56, '2025-06-12 20:06:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (59, 56, '2025-06-12 12:57:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (59, 55, '2025-06-12 19:45:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (60, 55, '2025-06-12 06:53:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (60, 56, '2025-06-12 13:51:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (61, 56, '2025-06-12 16:09:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (61, 55, '2025-06-12 16:17:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (62, 55, '2025-06-12 22:24:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (62, 56, '2025-06-12 14:57:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (63, 56, '2025-06-12 05:11:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (63, 55, '2025-06-12 05:13:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (64, 55, '2025-06-12 12:38:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (64, 56, '2025-06-12 18:38:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (65, 56, '2025-06-12 21:46:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (65, 55, '2025-06-12 14:12:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (66, 55, '2025-06-12 13:05:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (66, 56, '2025-06-12 10:44:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (67, 56, '2025-06-12 20:05:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (67, 55, '2025-06-12 03:03:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (68, 55, '2025-06-12 02:57:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (68, 56, '2025-06-12 07:36:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (69, 56, '2025-06-12 10:30:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (69, 55, '2025-06-12 16:15:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (70, 55, '2025-06-12 12:43:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (70, 56, '2025-06-12 07:58:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (71, 56, '2025-06-12 17:59:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (71, 55, '2025-06-12 22:16:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (72, 55, '2025-06-12 19:48:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (72, 56, '2025-06-12 12:19:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (73, 56, '2025-06-12 01:21:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (73, 55, '2025-06-12 18:20:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (74, 55, '2025-06-12 01:28:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (74, 56, '2025-06-12 12:18:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (75, 56, '2025-06-12 08:49:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (75, 55, '2025-06-12 13:32:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (76, 55, '2025-06-12 15:29:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (76, 56, '2025-06-12 17:08:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (77, 56, '2025-06-12 11:55:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (77, 55, '2025-06-12 09:27:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (78, 55, '2025-06-12 10:30:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (78, 56, '2025-06-12 16:34:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (79, 56, '2025-06-12 01:14:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (79, 55, '2025-06-12 13:58:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (80, 55, '2025-06-12 07:43:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (80, 56, '2025-06-12 09:54:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (81, 56, '2025-06-12 23:50:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (81, 55, '2025-06-12 05:50:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (82, 55, '2025-06-12 07:11:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (82, 56, '2025-06-12 00:37:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (83, 56, '2025-06-12 05:32:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (83, 55, '2025-06-12 16:59:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (84, 55, '2025-06-12 21:58:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (84, 56, '2025-06-12 07:21:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (85, 56, '2025-06-12 01:47:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (85, 55, '2025-06-12 15:46:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (86, 55, '2025-06-12 03:17:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (86, 56, '2025-06-12 02:07:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (87, 56, '2025-06-12 10:30:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (87, 55, '2025-06-12 12:50:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (88, 55, '2025-06-12 22:16:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (88, 56, '2025-06-12 05:57:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (89, 56, '2025-06-12 21:54:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (89, 55, '2025-06-12 22:09:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (90, 55, '2025-06-12 12:58:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (90, 56, '2025-06-12 16:50:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (91, 56, '2025-06-12 05:18:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (91, 55, '2025-06-12 01:12:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (92, 55, '2025-06-12 08:30:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (92, 56, '2025-06-12 18:37:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (93, 56, '2025-06-12 23:51:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (93, 55, '2025-06-12 23:45:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (94, 55, '2025-06-12 05:58:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (94, 56, '2025-06-12 23:45:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (95, 56, '2025-06-12 09:57:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (95, 55, '2025-06-12 04:31:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (96, 55, '2025-06-12 21:15:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (96, 56, '2025-06-12 18:48:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (97, 56, '2025-06-12 03:19:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (97, 55, '2025-06-12 17:44:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (98, 55, '2025-06-12 07:56:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (98, 56, '2025-06-12 13:39:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (99, 56, '2025-06-12 15:01:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (99, 55, '2025-06-12 05:08:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (100, 55, '2025-06-12 01:51:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (100, 56, '2025-06-12 00:11:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (101, 56, '2025-06-12 11:55:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (101, 55, '2025-06-12 12:47:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (102, 55, '2025-06-12 01:13:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (102, 56, '2025-06-12 05:05:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (103, 56, '2025-06-12 17:06:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (103, 55, '2025-06-12 16:05:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (104, 55, '2025-06-12 06:14:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (104, 56, '2025-06-12 11:46:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (105, 56, '2025-06-12 20:22:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (105, 55, '2025-06-12 18:00:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (106, 55, '2025-06-12 02:30:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (106, 56, '2025-06-12 11:30:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (107, 56, '2025-06-12 12:48:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (107, 55, '2025-06-12 17:45:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (108, 55, '2025-06-12 03:46:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (108, 56, '2025-06-12 13:01:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (109, 56, '2025-06-12 08:13:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (109, 55, '2025-06-12 16:50:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (110, 55, '2025-06-12 06:16:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (110, 56, '2025-06-12 17:57:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (111, 56, '2025-06-12 13:19:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (111, 55, '2025-06-12 07:06:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (112, 55, '2025-06-12 06:06:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (112, 56, '2025-06-12 15:47:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (113, 56, '2025-06-12 22:57:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (113, 55, '2025-06-12 20:40:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (114, 55, '2025-06-12 20:02:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (114, 56, '2025-06-12 02:27:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (115, 56, '2025-06-12 17:48:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (115, 55, '2025-06-12 13:27:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (116, 55, '2025-06-12 19:03:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (116, 56, '2025-06-12 22:01:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (117, 56, '2025-06-12 01:26:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (117, 55, '2025-06-12 21:06:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (118, 55, '2025-06-12 15:56:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (118, 56, '2025-06-12 20:29:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (119, 56, '2025-06-12 05:54:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (119, 55, '2025-06-12 01:59:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (120, 55, '2025-06-12 03:59:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (120, 56, '2025-06-12 03:54:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (121, 56, '2025-06-12 15:26:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (121, 55, '2025-06-12 23:53:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (122, 55, '2025-06-12 10:51:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (122, 56, '2025-06-12 03:30:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (123, 56, '2025-06-12 05:59:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (123, 55, '2025-06-12 06:20:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (124, 55, '2025-06-12 10:16:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (124, 56, '2025-06-12 09:50:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (125, 56, '2025-06-12 06:08:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (125, 55, '2025-06-12 09:27:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (126, 55, '2025-06-12 05:30:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (126, 56, '2025-06-12 10:05:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (127, 56, '2025-06-12 02:46:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (127, 55, '2025-06-12 00:40:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (128, 55, '2025-06-12 17:01:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (128, 56, '2025-06-12 00:49:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (129, 56, '2025-06-12 06:14:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (129, 55, '2025-06-12 21:43:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (130, 55, '2025-06-12 13:43:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (130, 56, '2025-06-12 04:43:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (131, 56, '2025-06-12 00:27:00');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (131, 55, '2025-06-12 23:57:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (132, 55, '2025-06-12 09:50:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (132, 56, '2025-06-12 20:30:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (133, 56, '2025-06-12 22:07:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (133, 55, '2025-06-12 08:12:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (134, 55, '2025-06-12 01:23:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (134, 56, '2025-06-12 14:16:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (135, 56, '2025-06-12 02:40:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (135, 55, '2025-06-12 21:06:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (136, 55, '2025-06-12 13:06:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (136, 56, '2025-06-12 16:03:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (137, 56, '2025-06-12 03:30:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (137, 55, '2025-06-12 00:04:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (138, 55, '2025-06-12 21:25:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (138, 56, '2025-06-12 15:47:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (139, 56, '2025-06-12 16:05:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (139, 55, '2025-06-12 09:11:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (140, 55, '2025-06-12 05:09:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (140, 56, '2025-06-12 11:35:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (141, 56, '2025-06-12 08:58:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (141, 55, '2025-06-12 09:48:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (142, 55, '2025-06-12 08:40:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (142, 56, '2025-06-12 01:18:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (143, 56, '2025-06-12 19:28:09');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (143, 55, '2025-06-12 19:38:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (144, 55, '2025-06-12 20:20:58');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (144, 56, '2025-06-12 13:40:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (145, 56, '2025-06-12 12:27:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (145, 55, '2025-06-12 18:27:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (146, 55, '2025-06-12 16:21:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (146, 56, '2025-06-12 02:08:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (147, 56, '2025-06-12 18:09:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (147, 55, '2025-06-12 10:41:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (148, 55, '2025-06-12 09:06:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (148, 56, '2025-06-12 04:05:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (149, 56, '2025-06-12 01:58:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (149, 55, '2025-06-12 06:45:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (150, 55, '2025-06-12 05:35:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (150, 56, '2025-06-12 02:05:15');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (151, 56, '2025-06-12 17:05:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (151, 55, '2025-06-12 10:01:52');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (152, 55, '2025-06-12 12:58:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (152, 56, '2025-06-12 19:40:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (153, 56, '2025-06-12 07:43:16');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (153, 55, '2025-06-12 11:54:44');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (154, 55, '2025-06-12 06:45:33');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (154, 56, '2025-06-12 15:36:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (155, 56, '2025-06-12 09:05:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (155, 55, '2025-06-12 23:22:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (156, 55, '2025-06-12 17:23:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (156, 56, '2025-06-12 07:13:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (157, 56, '2025-06-12 04:03:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (157, 55, '2025-06-12 02:33:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (158, 55, '2025-06-12 00:45:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (158, 56, '2025-06-12 14:01:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (159, 56, '2025-06-12 23:37:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (159, 55, '2025-06-12 22:53:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (160, 55, '2025-06-12 22:38:05');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (160, 56, '2025-06-12 15:55:10');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (161, 56, '2025-06-12 19:58:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (161, 55, '2025-06-12 01:46:25');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (162, 55, '2025-06-12 06:19:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (162, 56, '2025-06-12 10:42:34');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (163, 56, '2025-06-12 10:58:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (163, 55, '2025-06-12 16:18:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (164, 55, '2025-06-12 21:41:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (164, 56, '2025-06-12 19:20:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (165, 56, '2025-06-12 15:22:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (165, 55, '2025-06-12 05:30:45');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (166, 55, '2025-06-12 11:53:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (166, 56, '2025-06-12 08:03:39');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (167, 56, '2025-06-12 19:00:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (167, 55, '2025-06-12 12:59:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (168, 55, '2025-06-12 06:00:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (168, 56, '2025-06-12 20:32:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (169, 56, '2025-06-12 01:18:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (169, 55, '2025-06-12 10:56:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (170, 55, '2025-06-12 20:21:37');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (170, 56, '2025-06-12 23:28:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (171, 56, '2025-06-12 00:31:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (171, 55, '2025-06-12 07:12:47');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (172, 55, '2025-06-12 20:18:38');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (172, 56, '2025-06-12 13:38:14');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 56, '2025-06-12 19:06:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 55, '2025-06-12 12:05:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (173, 55, '2025-06-12 12:05:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (174, 55, '2025-06-12 20:44:04');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (174, 56, '2025-06-12 12:55:12');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (175, 56, '2025-06-12 17:55:27');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (175, 55, '2025-06-12 11:26:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (176, 55, '2025-06-12 04:40:24');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (176, 56, '2025-06-12 21:11:46');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (177, 56, '2025-06-12 14:04:11');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (177, 55, '2025-06-12 22:24:49');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (178, 55, '2025-06-12 10:14:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (178, 56, '2025-06-12 08:10:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (179, 56, '2025-06-12 09:24:28');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (179, 55, '2025-06-12 07:32:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (180, 55, '2025-06-12 18:23:22');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (180, 56, '2025-06-12 14:39:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (181, 56, '2025-06-12 01:12:08');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (181, 55, '2025-06-12 11:03:48');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (182, 55, '2025-06-12 01:41:59');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (182, 56, '2025-06-12 11:09:55');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (183, 56, '2025-06-12 18:30:02');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (183, 55, '2025-06-12 21:42:30');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (184, 55, '2025-06-12 20:42:17');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (184, 56, '2025-06-12 18:35:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (185, 56, '2025-06-12 01:13:20');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (185, 55, '2025-06-12 05:18:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (186, 55, '2025-06-12 15:09:01');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (186, 56, '2025-06-12 22:53:50');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (187, 56, '2025-06-12 21:19:32');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (187, 55, '2025-06-12 09:13:53');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (188, 55, '2025-06-12 23:37:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (188, 56, '2025-06-12 14:04:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (189, 56, '2025-06-12 16:02:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (189, 55, '2025-06-12 04:48:06');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (190, 55, '2025-06-12 07:36:31');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (190, 56, '2025-06-12 22:59:21');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (191, 56, '2025-06-12 21:35:26');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (191, 55, '2025-06-12 21:53:51');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (192, 55, '2025-06-12 00:53:43');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (192, 56, '2025-06-12 13:25:07');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (193, 56, '2025-06-12 05:50:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (193, 55, '2025-06-12 13:47:40');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (194, 55, '2025-06-12 02:09:13');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (194, 56, '2025-06-12 22:42:54');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (195, 56, '2025-06-12 04:03:35');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (195, 55, '2025-06-12 19:51:23');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (196, 55, '2025-06-12 02:53:56');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (196, 56, '2025-06-12 04:34:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (197, 56, '2025-06-12 08:32:36');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (197, 55, '2025-06-12 02:57:57');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (198, 55, '2025-06-12 06:08:03');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (198, 56, '2025-06-12 02:08:29');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (199, 56, '2025-06-12 10:32:41');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (199, 55, '2025-06-12 16:41:18');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (200, 55, '2025-06-12 00:50:19');
INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES (200, 56, '2025-06-12 03:29:27');

INSERT INTO leitura (fkSensor, umidade, dtRegistro) VALUES
(1, 56, '2025-06-12 12:00:00'),
(1, 55, '2025-06-12 12:00:00'),
(2, 55, '2025-06-12 08:00:00'),
(2, 56, '2025-06-12 04:00:00'),
(3, 56, '2025-06-12 08:00:00'),
(3, 55, '2025-06-12 04:00:00'),
(4, 55, '2025-06-12 16:00:00'),
(4, 56, '2025-06-12 04:00:00'),
(5, 56, '2025-06-12 20:00:00'),
(5, 55, '2025-06-12 12:00:00'),
(6, 55, '2025-06-12 04:00:00'),
(6, 56, '2025-06-12 20:00:00'),
(7, 56, '2025-06-12 04:00:00'),
(7, 55, '2025-06-12 04:00:00'),
(8, 55, '2025-06-12 04:00:00'),
(8, 56, '2025-06-12 04:00:00'),
(9, 56, '2025-06-12 16:00:00'),
(9, 55, '2025-06-12 20:00:00'),
(10, 55, '2025-06-12 20:00:00'),
(10, 56, '2025-06-12 16:00:00'),
(11, 56, '2025-06-12 20:00:00'),
(11, 55, '2025-06-12 12:00:00'),
(12, 55, '2025-06-12 16:00:00'),
(12, 56, '2025-06-12 00:00:00'),
(13, 56, '2025-06-12 16:00:00'),
(13, 55, '2025-06-12 12:00:00'),
(14, 55, '2025-06-12 00:00:00'),
(14, 56, '2025-06-12 16:00:00'),
(15, 56, '2025-06-12 20:00:00'),
(15, 55, '2025-06-12 04:00:00'),
(16, 55, '2025-06-12 16:00:00'),
(16, 56, '2025-06-12 04:00:00'),
(17, 56, '2025-06-12 20:00:00'),
(17, 55, '2025-06-12 12:00:00'),
(18, 55, '2025-06-12 12:00:00'),
(18, 56, '2025-06-12 20:00:00'),
(19, 56, '2025-06-12 16:00:00'),
(19, 55, '2025-06-12 12:00:00'),
(20, 55, '2025-06-12 20:00:00'),
(20, 56, '2025-06-12 20:00:00'),
(21, 56, '2025-06-12 12:00:00'),
(21, 55, '2025-06-12 16:00:00'),
(22, 55, '2025-06-12 20:00:00'),
(22, 56, '2025-06-12 04:00:00'),
(23, 56, '2025-06-12 20:00:00'),
(23, 55, '2025-06-12 04:00:00'),
(24, 55, '2025-06-12 08:00:00'),
(24, 56, '2025-06-12 04:00:00'),
(25, 56, '2025-06-12 04:00:00'),
(25, 55, '2025-06-12 08:00:00'),
(26, 55, '2025-06-12 04:00:00'),
(26, 56, '2025-06-12 04:00:00'),
(27, 56, '2025-06-12 12:00:00'),
(27, 55, '2025-06-12 00:00:00'),
(28, 55, '2025-06-12 12:00:00'),
(28, 56, '2025-06-12 20:00:00'),
(29, 56, '2025-06-12 12:00:00'),
(29, 55, '2025-06-12 04:00:00'),
(30, 55, '2025-06-12 20:00:00'),
(30, 56, '2025-06-12 08:00:00'),
(31, 56, '2025-06-12 20:00:00'),
(31, 55, '2025-06-12 20:00:00'),
(32, 55, '2025-06-12 00:00:00'),
(32, 56, '2025-06-12 00:00:00'),
(33, 56, '2025-06-12 20:00:00'),
(33, 55, '2025-06-12 04:00:00'),
(34, 55, '2025-06-12 12:00:00'),
(34, 56, '2025-06-12 12:00:00'),
(35, 56, '2025-06-12 00:00:00'),
(35, 55, '2025-06-12 00:00:00'),
(36, 55, '2025-06-12 08:00:00'),
(36, 56, '2025-06-12 08:00:00'),
(37, 56, '2025-06-12 16:00:00'),
(37, 55, '2025-06-12 12:00:00'),
(38, 55, '2025-06-12 08:00:00'),
(38, 56, '2025-06-12 08:00:00'),
(39, 56, '2025-06-12 12:00:00'),
(39, 55, '2025-06-12 16:00:00'),
(40, 55, '2025-06-12 08:00:00'),
(40, 56, '2025-06-12 20:00:00'),
(41, 56, '2025-06-12 12:00:00'),
(41, 55, '2025-06-12 20:00:00'),
(42, 55, '2025-06-12 16:00:00'),
(42, 56, '2025-06-12 04:00:00'),
(43, 56, '2025-06-12 04:00:00'),
(43, 55, '2025-06-12 16:00:00'),
(44, 55, '2025-06-12 08:00:00'),
(44, 56, '2025-06-12 08:00:00'),
(45, 56, '2025-06-12 12:00:00'),
(45, 55, '2025-06-12 04:00:00'),
(46, 55, '2025-06-12 16:00:00'),
(46, 56, '2025-06-12 12:00:00'),
(47, 56, '2025-06-12 08:00:00'),
(47, 55, '2025-06-12 16:00:00'),
(48, 55, '2025-06-12 04:00:00'),
(48, 56, '2025-06-12 20:00:00'),
(49, 56, '2025-06-12 20:00:00'),
(49, 55, '2025-06-12 16:00:00'),
(50, 55, '2025-06-12 16:00:00'),
(50, 56, '2025-06-12 08:00:00'),
(51, 56, '2025-06-12 08:00:00'),
(51, 55, '2025-06-12 08:00:00'),
(52, 55, '2025-06-12 04:00:00'),
(52, 56, '2025-06-12 20:00:00'),
(53, 56, '2025-06-12 12:00:00'),
(53, 55, '2025-06-12 08:00:00'),
(54, 55, '2025-06-12 20:00:00'),
(54, 56, '2025-06-12 12:00:00'),
(55, 56, '2025-06-12 20:00:00'),
(55, 55, '2025-06-12 08:00:00'),
(56, 55, '2025-06-12 16:00:00'),
(56, 56, '2025-06-12 20:00:00'),
(57, 56, '2025-06-12 04:00:00'),
(57, 55, '2025-06-12 12:00:00'),
(58, 55, '2025-06-12 08:00:00'),
(58, 56, '2025-06-12 20:00:00'),
(59, 56, '2025-06-12 12:00:00'),
(59, 55, '2025-06-12 20:00:00'),
(60, 55, '2025-06-12 08:00:00'),
(60, 56, '2025-06-12 12:00:00'),
(61, 56, '2025-06-12 16:00:00'),
(61, 55, '2025-06-12 16:00:00'),
(62, 55, '2025-06-12 20:00:00'),
(62, 56, '2025-06-12 16:00:00'),
(63, 56, '2025-06-12 04:00:00'),
(63, 55, '2025-06-12 04:00:00'),
(64, 55, '2025-06-12 12:00:00'),
(64, 56, '2025-06-12 20:00:00'),
(65, 56, '2025-06-12 20:00:00'),
(65, 55, '2025-06-12 16:00:00'),
(66, 55, '2025-06-12 12:00:00'),
(66, 56, '2025-06-12 12:00:00'),
(67, 56, '2025-06-12 20:00:00'),
(67, 55, '2025-06-12 04:00:00'),
(68, 55, '2025-06-12 04:00:00'),
(68, 56, '2025-06-12 08:00:00'),
(69, 56, '2025-06-12 12:00:00'),
(69, 55, '2025-06-12 16:00:00'),
(70, 55, '2025-06-12 12:00:00'),
(70, 56, '2025-06-12 08:00:00'),
(71, 56, '2025-06-12 16:00:00'),
(71, 55, '2025-06-12 20:00:00'),
(72, 55, '2025-06-12 20:00:00'),
(72, 56, '2025-06-12 12:00:00'),
(73, 56, '2025-06-12 00:00:00'),
(73, 55, '2025-06-12 20:00:00'),
(74, 55, '2025-06-12 00:00:00'),
(74, 56, '2025-06-12 12:00:00'),
(75, 56, '2025-06-12 08:00:00'),
(75, 55, '2025-06-12 12:00:00'),
(76, 55, '2025-06-12 16:00:00'),
(76, 56, '2025-06-12 16:00:00'),
(77, 56, '2025-06-12 12:00:00'),
(77, 55, '2025-06-12 08:00:00'),
(78, 55, '2025-06-12 12:00:00'),
(78, 56, '2025-06-12 16:00:00'),
(79, 56, '2025-06-12 00:00:00'),
(79, 55, '2025-06-12 12:00:00'),
(80, 55, '2025-06-12 08:00:00'),
(80, 56, '2025-06-12 08:00:00'),
(81, 56, '2025-06-12 20:00:00'),
(81, 55, '2025-06-12 04:00:00'),
(82, 55, '2025-06-12 08:00:00'),
(82, 56, '2025-06-12 00:00:00'),
(83, 56, '2025-06-12 04:00:00'),
(83, 55, '2025-06-12 16:00:00'),
(84, 55, '2025-06-12 20:00:00'),
(84, 56, '2025-06-12 08:00:00'),
(85, 56, '2025-06-12 00:00:00'),
(85, 55, '2025-06-12 16:00:00'),
(86, 55, '2025-06-12 04:00:00'),
(86, 56, '2025-06-12 04:00:00'),
(87, 56, '2025-06-12 12:00:00'),
(87, 55, '2025-06-12 12:00:00'),
(88, 55, '2025-06-12 20:00:00'),
(88, 56, '2025-06-12 04:00:00'),
(89, 56, '2025-06-12 20:00:00'),
(89, 55, '2025-06-12 20:00:00'),
(90, 55, '2025-06-12 12:00:00'),
(90, 56, '2025-06-12 16:00:00'),
(91, 56, '2025-06-12 04:00:00'),
(91, 55, '2025-06-12 00:00:00'),
(92, 55, '2025-06-12 08:00:00'),
(92, 56, '2025-06-12 20:00:00'),
(93, 56, '2025-06-12 20:00:00'),
(93, 55, '2025-06-12 20:00:00'),
(94, 55, '2025-06-12 04:00:00'),
(94, 56, '2025-06-12 20:00:00'),
(95, 56, '2025-06-12 08:00:00'),
(95, 55, '2025-06-12 04:00:00'),
(96, 55, '2025-06-12 20:00:00'),
(96, 56, '2025-06-12 20:00:00'),
(97, 56, '2025-06-12 04:00:00'),
(97, 55, '2025-06-12 16:00:00'),
(98, 55, '2025-06-12 08:00:00'),
(98, 56, '2025-06-12 12:00:00'),
(99, 56, '2025-06-12 16:00:00'),
(99, 55, '2025-06-12 04:00:00'),
(100, 55, '2025-06-12 00:00:00'),
(100, 56, '2025-06-12 00:00:00'),
(101, 56, '2025-06-12 12:00:00'),
(101, 55, '2025-06-12 12:00:00'),
(102, 55, '2025-06-12 00:00:00'),
(102, 56, '2025-06-12 04:00:00'),
(103, 56, '2025-06-12 16:00:00'),
(103, 55, '2025-06-12 16:00:00'),
(104, 55, '2025-06-12 08:00:00'),
(104, 56, '2025-06-12 12:00:00'),
(105, 56, '2025-06-12 20:00:00'),
(105, 55, '2025-06-12 20:00:00'),
(106, 55, '2025-06-12 04:00:00'),
(106, 56, '2025-06-12 12:00:00'),
(107, 56, '2025-06-12 12:00:00'),
(107, 55, '2025-06-12 16:00:00'),
(108, 55, '2025-06-12 04:00:00'),
(108, 56, '2025-06-12 12:00:00'),
(109, 56, '2025-06-12 08:00:00'),
(109, 55, '2025-06-12 16:00:00'),
(110, 55, '2025-06-12 08:00:00'),
(110, 56, '2025-06-12 16:00:00'),
(111, 56, '2025-06-12 12:00:00'),
(111, 55, '2025-06-12 08:00:00'),
(112, 55, '2025-06-12 08:00:00'),
(112, 56, '2025-06-12 16:00:00'),
(113, 56, '2025-06-12 20:00:00'),
(113, 55, '2025-06-12 20:00:00'),
(114, 55, '2025-06-12 20:00:00'),
(114, 56, '2025-06-12 04:00:00'),
(115, 56, '2025-06-12 16:00:00'),
(115, 55, '2025-06-12 12:00:00'),
(116, 55, '2025-06-12 20:00:00'),
(116, 56, '2025-06-12 20:00:00'),
(117, 56, '2025-06-12 00:00:00'),
(117, 55, '2025-06-12 20:00:00'),
(118, 55, '2025-06-12 16:00:00'),
(118, 56, '2025-06-12 20:00:00'),
(119, 56, '2025-06-12 04:00:00'),
(119, 55, '2025-06-12 00:00:00'),
(120, 55, '2025-06-12 04:00:00'),
(120, 56, '2025-06-12 04:00:00'),
(121, 56, '2025-06-12 16:00:00'),
(121, 55, '2025-06-12 20:00:00'),
(122, 55, '2025-06-12 12:00:00'),
(122, 56, '2025-06-12 04:00:00'),
(123, 56, '2025-06-12 04:00:00'),
(123, 55, '2025-06-12 08:00:00'),
(124, 55, '2025-06-12 12:00:00'),
(124, 56, '2025-06-12 08:00:00'),
(125, 56, '2025-06-12 08:00:00'),
(125, 55, '2025-06-12 08:00:00'),
(126, 55, '2025-06-12 04:00:00'),
(126, 56, '2025-06-12 12:00:00'),
(127, 56, '2025-06-12 04:00:00'),
(127, 55, '2025-06-12 00:00:00'),
(128, 55, '2025-06-12 16:00:00'),
(128, 56, '2025-06-12 00:00:00'),
(129, 56, '2025-06-12 08:00:00'),
(129, 55, '2025-06-12 20:00:00'),
(130, 55, '2025-06-12 12:00:00'),
(130, 56, '2025-06-12 04:00:00'),
(131, 56, '2025-06-12 00:00:00'),
(131, 55, '2025-06-12 20:00:00'),
(132, 55, '2025-06-12 08:00:00'),
(132, 56, '2025-06-12 20:00:00'),
(133, 56, '2025-06-12 20:00:00'),
(133, 55, '2025-06-12 08:00:00'),
(134, 55, '2025-06-12 00:00:00'),
(134, 56, '2025-06-12 16:00:00'),
(135, 56, '2025-06-12 04:00:00'),
(135, 55, '2025-06-12 20:00:00'),
(136, 55, '2025-06-12 12:00:00'),
(136, 56, '2025-06-12 16:00:00'),
(137, 56, '2025-06-12 04:00:00'),
(137, 55, '2025-06-12 00:00:00'),
(138, 55, '2025-06-12 20:00:00'),
(138, 56, '2025-06-12 16:00:00'),
(139, 56, '2025-06-12 16:00:00'),
(139, 55, '2025-06-12 08:00:00'),
(140, 55, '2025-06-12 04:00:00'),
(140, 56, '2025-06-12 12:00:00'),
(141, 56, '2025-06-12 08:00:00'),
(141, 55, '2025-06-12 08:00:00'),
(142, 55, '2025-06-12 08:00:00'),
(142, 56, '2025-06-12 00:00:00'),
(143, 56, '2025-06-12 20:00:00'),
(143, 55, '2025-06-12 20:00:00'),
(144, 55, '2025-06-12 20:00:00'),
(144, 56, '2025-06-12 12:00:00'),
(145, 56, '2025-06-12 12:00:00'),
(145, 55, '2025-06-12 20:00:00'),
(146, 55, '2025-06-12 16:00:00'),
(146, 56, '2025-06-12 04:00:00'),
(147, 56, '2025-06-12 20:00:00'),
(147, 55, '2025-06-12 12:00:00'),
(148, 55, '2025-06-12 08:00:00'),
(148, 56, '2025-06-12 04:00:00'),
(149, 56, '2025-06-12 00:00:00'),
(149, 55, '2025-06-12 08:00:00'),
(150, 55, '2025-06-12 04:00:00'),
(150, 56, '2025-06-12 04:00:00'),
(151, 56, '2025-06-12 16:00:00'),
(151, 55, '2025-06-12 12:00:00'),
(152, 55, '2025-06-12 12:00:00'),
(152, 56, '2025-06-12 20:00:00'),
(153, 56, '2025-06-12 08:00:00'),
(153, 55, '2025-06-12 12:00:00'),
(154, 55, '2025-06-12 08:00:00'),
(154, 56, '2025-06-12 16:00:00'),
(155, 56, '2025-06-12 08:00:00'),
(155, 55, '2025-06-12 20:00:00'),
(156, 55, '2025-06-12 16:00:00'),
(156, 56, '2025-06-12 08:00:00'),
(157, 56, '2025-06-12 04:00:00'),
(157, 55, '2025-06-12 04:00:00'),
(158, 55, '2025-06-12 00:00:00'),
(158, 56, '2025-06-12 16:00:00'),
(159, 56, '2025-06-12 20:00:00'),
(159, 55, '2025-06-12 20:00:00'),
(160, 55, '2025-06-12 20:00:00'),
(160, 56, '2025-06-12 16:00:00'),
(161, 56, '2025-06-12 20:00:00'),
(161, 55, '2025-06-12 00:00:00'),
(162, 55, '2025-06-12 08:00:00'),
(162, 56, '2025-06-12 12:00:00'),
(163, 56, '2025-06-12 12:00:00'),
(163, 55, '2025-06-12 16:00:00'),
(164, 55, '2025-06-12 20:00:00'),
(164, 56, '2025-06-12 20:00:00'),
(165, 56, '2025-06-12 16:00:00'),
(165, 55, '2025-06-12 04:00:00'),
(166, 55, '2025-06-12 12:00:00'),
(166, 56, '2025-06-12 08:00:00'),
(167, 56, '2025-06-12 20:00:00'),
(167, 55, '2025-06-12 12:00:00'),
(168, 55, '2025-06-12 08:00:00'),
(168, 56, '2025-06-12 20:00:00'),
(169, 56, '2025-06-12 00:00:00'),
(169, 55, '2025-06-12 12:00:00'),
(170, 55, '2025-06-12 20:00:00'),
(170, 56, '2025-06-12 20:00:00'),
(171, 56, '2025-06-12 00:00:00'),
(171, 55, '2025-06-12 08:00:00'),
(172, 55, '2025-06-12 20:00:00'),
(172, 56, '2025-06-12 12:00:00'),
(173, 56, '2025-06-12 20:00:00'),
(173, 55, '2025-06-12 12:00:00'),
(173, 55, '2025-06-12 12:00:00'),
(174, 55, '2025-06-12 20:00:00'),
(174, 56, '2025-06-12 12:00:00'),
(175, 56, '2025-06-12 16:00:00'),
(175, 55, '2025-06-12 12:00:00'),
(176, 55, '2025-06-12 04:00:00'),
(176, 56, '2025-06-12 20:00:00'),
(177, 56, '2025-06-12 16:00:00'),
(177, 55, '2025-06-12 20:00:00'),
(178, 55, '2025-06-12 12:00:00'),
(178, 56, '2025-06-12 08:00:00'),
(179, 56, '2025-06-12 08:00:00'),
(179, 55, '2025-06-12 08:00:00'),
(180, 55, '2025-06-12 20:00:00'),
(180, 56, '2025-06-12 16:00:00'),
(181, 56, '2025-06-12 00:00:00'),
(181, 55, '2025-06-12 12:00:00'),
(182, 55, '2025-06-12 00:00:00'),
(182, 56, '2025-06-12 12:00:00'),
(183, 56, '2025-06-12 20:00:00'),
(183, 55, '2025-06-12 20:00:00'),
(184, 55, '2025-06-12 20:00:00'),
(184, 56, '2025-06-12 20:00:00'),
(185, 56, '2025-06-12 00:00:00'),
(185, 55, '2025-06-12 04:00:00'),
(186, 55, '2025-06-12 16:00:00'),
(186, 56, '2025-06-12 20:00:00'),
(187, 56, '2025-06-12 20:00:00'),
(187, 55, '2025-06-12 08:00:00'),
(188, 55, '2025-06-12 20:00:00'),
(188, 56, '2025-06-12 16:00:00'),
(189, 56, '2025-06-12 16:00:00'),
(189, 55, '2025-06-12 04:00:00'),
(190, 55, '2025-06-12 08:00:00'),
(190, 56, '2025-06-12 20:00:00'),
(191, 56, '2025-06-12 20:00:00'),
(191, 55, '2025-06-12 20:00:00'),
(192, 55, '2025-06-12 00:00:00'),
(192, 56, '2025-06-12 12:00:00'),
(193, 56, '2025-06-12 04:00:00'),
(193, 55, '2025-06-12 12:00:00'),
(194, 55, '2025-06-12 04:00:00'),
(194, 56, '2025-06-12 20:00:00'),
(195, 56, '2025-06-12 04:00:00'),
(195, 55, '2025-06-12 20:00:00'),
(196, 55, '2025-06-12 04:00:00'),
(196, 56, '2025-06-12 04:00:00'),
(197, 56, '2025-06-12 08:00:00'),
(197, 55, '2025-06-12 04:00:00'),
(198, 55, '2025-06-12 08:00:00'),
(198, 56, '2025-06-12 04:00:00'),
(199, 56, '2025-06-12 12:00:00'),
(199, 55, '2025-06-12 16:00:00'),
(200, 55, '2025-06-12 00:00:00'),
(200, 56, '2025-06-12 04:00:00');

SELECT TRUNCATE(AVG(umidade),2) AS MediaUmidadeSetor, date_format(dataCaptura, '%H:%i') AS dataCaptura 
FROM vw_kpis WHERE fkEmpresa = 1 AND nomeFazenda = 'Recanto do Sol' AND DAY(dataCaptura) = (SELECT DAY(CURRENT_DATE))
AND nomeHectares = 'Hectare 1'
AND (dataCaptura LIKE '%00:00%' OR dataCaptura LIKE '%04:00%' OR dataCaptura LIKE '%08:00%'
OR dataCaptura LIKE '%12:00%' OR dataCaptura LIKE '%16:00%' OR dataCaptura LIKE '%20:00%')
GROUP BY nomeFazenda, dataCaptura
ORDER BY dataCaptura;