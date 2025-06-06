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
 idHectar int auto_increment,
 nomeHectar varchar(100),
 fkFazenda int, 
 constraint fkFazendaHectare foreign key (fkFazenda) references fazenda(idFazenda),
 constraint pkCompostaHectares primary key (idHectar, fkFazenda) 
);

create table setores (
idSetores int auto_increment,
nomeSensor varchar(45),
fkHectare int,
	constraint fkHectareSetor
    foreign key (fkHectare)
    references hectares(idHectar),
    constraint pkCompostaSetores
    primary key (idSetores, fkHectare)
);


INSERT INTO hectares(nomeFazenda, fkEmpresa) VALUES('Fazenda Cacau', 1);
INSERT INTO setores(nomeSensor, fkhectareSetor) VALUES('Umidade', 1);


create table sensores (
idSensor int auto_increment,
numSerie varchar (45) not null,
situacao varchar(20) not null,
fkSetores int,
fkHectare int,
	constraint fkSetores foreign key (fkSetores) references setores(idSetores),
constraint fkHectareSensores foreign key (fkHectare) references hectares(idHectar),
primary key (idSensor, fkSetores, fkHectare)
);


INSERT INTO sensores(numSerie, situacao, fkSetores, fkHectareSensores) VALUES
('N25', 'Ativo', 1, 1);

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

-- SELECT KPI 1
CREATE VIEW vw_kpis AS 
SELECT f.nome AS nomeFazenda, h.nomeHectares AS nomeHectares, se.nomeSetores AS nomeSetores, s.idSensor AS codSensor, l.umidade AS umidade, l.dtRegistro AS dataCaptura FROM leitura AS l
	JOIN sensores AS s
		ON l.fkSensor = s.idSensor
	JOIN setores AS se
		ON s.fkSetores = se.idSetores
	JOIN hectares AS h
		ON se.fkHectare = h.idHectares
	JOIN fazenda AS f
		ON h.fkFazenda = f.idFazenda
	GROUP BY f.nome, h.nomeHectares, se.nomeSetores, s.idSensor, l.umidade, l.dtRegistro; 

SELECT * FROM vw_kpis;
    
    
-- Retornam os 5 últimos (fazer a média no JS)
-- SELECT KPI 1 - Plantação
SELECT nomeFazenda, umidade AS UmidadeFazenda FROM vw_kpis WHERE nomeFazenda = 'Recanto do Sol' LIMIT 5;

-- SELECT KPI 1 - Hectares
SELECT nomeFazenda, nomeHectares AS Hectare, umidade AS UmidadeFazenda FROM vw_kpis WHERE nomeFazenda = 'Recanto do Sol' AND nomeHectares = 'Hectare 1' LIMIT 5;

-- SELECT KPI 1 - Setores
SELECT nomeFazenda, nomeHectares, umidade, nomeSetores  
FROM vw_kpis WHERE nomeFazenda = 'Recanto do Sol' AND nomeHectares = 'Hectare 1' AND nomeSetores  = 'Setor 1 - Hectare 1' LIMIT 5;

-- SELECT KPI 1 - Sensor
SELECT nomeFazenda, nomeHectares, umidade, nomeSetores, codSensor 
FROM vw_kpis WHERE nomeFazenda = 'Recanto do Sol' AND nomeHectares = 'Hectare 1' AND nomeSetores  = 'Setor 1 - Hectare 1' AND codSensor = 1;


-- SELECT KPI 2 - Plantação
SELECT nomeFazenda, AVG(umidade) AS MediaUmidadeFazenda FROM vw_kpis WHERE nomeFazenda = 'Recanto do Sol' AND dataCaptura LIKE '%2025-06-06%' ;


SELECT * FROM leitura;

    




    


	