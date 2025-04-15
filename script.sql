create database MaisCacau_pi;  

use MaisCacau_pi; 

create table  cliente (
idCliente int primary  key auto_increment,
nome varchar (100) not null,
cpf char (11) not null,
cnpj char (14) not null, 
email varchar (80) not null,
senha varchar (15) not null,
telefone varchar (11),
cidade varchar (60),
estadoUF char (2)
); 
 
 create table plantacao (
idPlant int primary key auto_increment,
nomeFazenda varchar (100) not null,
hectaresPlant float not null,
tipoPlant varchar (50) not null, 
tipoCacau varchar (50) not null, 
tipoClima varchar (50) not null,
tipoAdubo varchar (50) not null,
fkCliente int not null,
constraint chkTipoPlant check(tipoPlant in('Sombreado', 'Pleno Sol', 'Extra-Tivista')),
constraint fk_plantacao_cliente foreign key(fkCliente) references Cliente (idCliente)
); 

create table Sensor (
idSensor int auto_increment,
fkPlantacao int,
constraint pkComposta primary key(idSensor, fkPlantacao),
dtUltimaManutencao date, 
numSerie varchar (45),
situacao varchar(20),
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

insert into cliente (cpf, cnpj, nome, email, senha, telefone, cidade, estadoUf) values
('02551289084', '36742727000191', 'Irmãos & Agricultura', 'irmaos.agricultura@gmail.com', 'irmãos123', '27983793113', 'Colatina','ES'),
('67209940189', '65033138000132', 'Fazendas Araujo', 'contato@fazendas.araujo', 'FamiliaAraujo', null, 'Gurupi','TO'),
('00331470195', '20124173000129', 'Colheita Feliz', 'contato@colheitafeliz.com', 'ColheitaFeliz', '31998795436', 'Belo Horizonte','MG'),
('82936716888', '86537439000173', 'Santa Ana Agricultura', 'santaana.agricultura@outloook.com', '01234567890', null , 'Porto Alegre','RS');

update cliente set telefone = '11976541032', email = 'santaana.agricultura@outlook.com' where idCliente = 4;

SELECT cpf AS 'CPF', cnpj AS 'CNPJ', nome AS 'Nome', email AS 'Email', senha AS 'Senha', IFNULL(telefone, 'Sem telefone') AS 'Telefone', cidade AS 'Cidade', estadoUf AS 'Estado', ifnull(telefone, 'Sem telefone') as 'Telefone'
FROM cliente;

insert into plantacao (nomeFazenda, hectaresPlant, tipoPlant, tipoCacau, tipoClima, tipoAdubo, fkCliente) values
('Fazenda Santa Origem', 87, 'Sombreado', 'Forasteiro', 'Equatorial', 'Orgânico', 1),
('Caminho do paraíso', 70, 'Extra-Tivista', 'Trinitário', 'Tropical Semi-Úmido', 'Mineral', 2),
('Fazenda do Titio', 129, 'Pleno Sol', 'Trinitário', 'Tropical Úmido', 'Mineral', 2),
('Fazenda Feliz', 105, 'Sombreado', 'Criollo', 'Tropical Semi-Árido', 'Orgânico', 3),
('Fazenda Santa Ana', 200, 'Sombreado', 'Criollo', 'Equatorial', 'Orgânico', 4);

select idCliente, nome, cnpj, email, ifnull(telefone, 'Sem telefone') as Telefone, cidade, estadoUF as 'UF', nomeFazenda as 'Fazenda', tipoPlant, tipoCacau from cliente
inner join plantacao on fkCliente =  idCliente;

insert into sensor(fkPlantacao, dtUltimaManutencao, numSerie, situacao) values
(1, null, '42698', 'Operando normalmente'),
(2, null, '27158', 'Operando normalmente'),
(3, '2024-07-28', '24385', 'Operando normalmente'),
(3, null, '21506', 'Necessita reparo'),
(4, '2025-04-10', '74385', 'Operando normalmente'),
(5, '2025-02-26', '74586', 'Operando normalmente'),
(5, null, '53759', 'Necessita reparo'),
(5, '2025-01-01', '26101', 'Operando normalmente');

select idSensor, idPlant, nomeFazenda as 'Fazenda', ifnull(dtUltimaManutencao, 'Nenhuma manutenção feita') as 'Data última manutenção', situacao from sensor
inner join plantacao on fkPlantacao = idPlant;

select idSensor, nomeFazenda as 'Fazenda', ifnull(dtUltimaManutencao, 'Nenhuma manutenção feita') as 'Data última manutenção', situacao from sensor
inner join plantacao on fkPlantacao = idPlant
where idPlant = 5 and situacao = 'Necessita reparo';