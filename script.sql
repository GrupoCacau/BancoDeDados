create database MaisCacau_pi;  
use MaisCacau_pi; 

create table  empresa (
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
 
 
 
 create table plantacao (
idPlant int primary key auto_increment,
nomeFazenda varchar (100) not null,
hectaresPlant float not null,
tipoPlant varchar (50) not null, 
tipoCacau varchar (50) not null, 
tipoClima varchar (50) not null,
tipoAdubo varchar (50) not null,
fkEmpresa int not null,
constraint chkTipoPlant check(tipoPlant in('Sombreado', 'Pleno Sol', 'Extra-Tivista')),
constraint fk_plantacao_empresa foreign key(fkEmpresa) references empresa (idEmpresa)
); 

create table Sensor (
idSensor int primary key auto_increment,
numSerie varchar (45) not null,
situacao varchar(20) not null,
fkplantacao int,
constraint chkSituacao check(situacao in('Operando normalmente','Necessita reparo')),
constraint fk_sensor_plantacao foreign key (fkPlantacao) references plantacao(idPlant)
); 

create table Leitura(
idLeitura int auto_increment,
fkSensor int,
constraint pkComposta primary key(idLeitura, fkSensor),
umidade int not null,
dtRegistro datetime default current_timestamp,
constraint fk_leitura_sensor foreign key (fkSensor) references sensor(idSensor)
);


insert into Empresa (nome,cnpj,telefone, email, cep, numero,logradouro,bairro, estadoUf, cidade, complemento, codigoAtivacao) values
('Cacau do Vale Agroindustrial Ltda', '12345678000195',  '11999998888',  'contato@techsolutions.com.br', 
 '04547000', '123',  'Av. das Nações Unidas', 'Brooklin', 'SP', 'São Paulo',   'Conjunto 42',  'ABC123'),
('Sementes de Ouro Cacau e Agricultura ME', '39847215000167', '11987654321', 'contato@globaltech.com.br', 
'04578903', '1001', 'Rua Funchal', 'Vila Olímpia', 'SP', 'São Paulo', '5º andar - Sala 502', 'GTX123'),
('Floresta Cacau e Produtos Naturais EIRELI', '04729166000122', '31988776655', 'vendas@ecolife.com.br', 
'30140071', '250', 'Av. do Contorno', 'Funcionários', 'MG', 'Belo Horizonte', 'Loja 01', 'ECO456');



update empresa set telefone = '11976541032', email = 'santaana.agricultura@outlook.com' where idEmpresa = 2;

SELECT cnpj AS 'CNPJ', nome AS 'Nome', email AS 'Email', IFNULL(telefone, 'Sem telefone') AS 'Telefone', cidade AS 'Cidade', estadoUf AS 'Estado', ifnull(telefone, 'Sem telefone') as 'Telefone'
FROM empresa;

insert into plantacao (nomeFazenda, hectaresPlant, tipoPlant, tipoCacau, tipoClima, tipoAdubo, fkEmpresa) values
('Fazenda Santa Origem', 87, 'Sombreado', 'Forasteiro', 'Equatorial', 'Orgânico', 1),
('Caminho do paraíso', 70, 'Extra-Tivista', 'Trinitário', 'Tropical Semi-Úmido', 'Mineral', 2),
('Fazenda do Titio', 129, 'Pleno Sol', 'Trinitário', 'Tropical Úmido', 'Mineral', 2),
('Fazenda Feliz', 105, 'Sombreado', 'Criollo', 'Tropical Semi-Árido', 'Orgânico', 3),
('Fazenda Santa Ana', 200, 'Sombreado', 'Criollo', 'Equatorial', 'Orgânico', 1);

select idEmpresa, idPlant, nome, cnpj, email, ifnull(telefone, 'Sem telefone') as Telefone, cidade, estadoUF as 'UF', nomeFazenda as 'Fazenda', tipoPlant, tipoCacau from empresa
inner join plantacao on fkEmpresa =  idEmpresa;

insert into sensor(fkPlantacao, numSerie, situacao) values
(1, '42698', 'Operando normalmente'),
(2, '27158', 'Operando normalmente'),
(3, '24385', 'Operando normalmente'),
(3,'21506', 'Necessita reparo'),
(4, '74385', 'Operando normalmente'),
(5, '74586', 'Operando normalmente'),
(5, '53759', 'Necessita reparo'),
(5, '26101', 'Operando normalmente');

select idSensor, idPlant, nomeFazenda as 'Fazenda', situacao as 'Status' from sensor
inner join plantacao on fkPlantacao = idPlant;

select idSensor, nomeFazenda as 'Fazenda',  situacao as  'Status'  from sensor
inner join plantacao on fkPlantacao = idPlant
where idPlant = 5 and situacao = 'Necessita reparo';


drop table leitura;
drop table sensor;
drop table plantacao;
drop table funcionario;
drop table empresa;