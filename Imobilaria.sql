create database Imobilaria;

use imobilaria;

create table cliente
(id_cliente int auto_increment primary key,
nome_cliente varchar(45) not null,
cpf_ou_cnpj varchar(20) not null,
telefone varchar(20) not null,
email varchar(45) not null,
tipo_cliente varchar(35) not null)
character set utf8mb4;

create table imoveis
(cod_imovel int auto_increment primary key,
nome_imovel varchar(45) not null,
categoria enum('Casa', 'Apartamento', 'Sala comercial', 'Terreno') not null,
endereco varchar(60) not null,
bairro varchar(25) not null,
valor_aluguel decimal(10,2) not null,
disponibilidade enum('Disponivel', 'Indisponivel') not null,
pkid_proprietario int unique,
foreign key (pkid_proprietario) references proprietario(id_proprietario))
character set utf8mb4;

create table corretor
(id_corretor int auto_increment primary key,
nome_corretor varchar(45) not null,
creci varchar(20) unique not null,
telefone varchar(20) not null,
email varchar(45) not null)
character set utf8mb4;

create table aluguel
(id_aluguel int primary key auto_increment,
fkcod_imovel int unique not null,
inquilino int unique not null,
fkid_corretor int unique not null,
data_inicio date not null,
data_fim date not null,
valor_final decimal(10,2) not null,
status_aluguel enum('Ativo', 'Encerrado') not null,
foreign key (fkcod_imovel) references imoveis(cod_imovel),
foreign key (inquilino) references cliente(id_cliente),
foreign key (fkid_corretor) references corretor(id_corretor))
character set utf8mb4;

create table proprietario
(id_proprietario int auto_increment primary key,
nome_proprietario varchar(45) not null,
endereco varchar(60) not null,
telefone varchar(20) not null,
email varchar(35) not null)
character set utf8mb4;

Delimiter $$
create procedure localizarimovel(id_imovel int)
begin
	select * from imoveis where cod_imovel = id_imovel;
end;
Delimiter;

Delimiter $$
create procedure localizarcliente(idcliente int)
begin
	select * from cliente where id_cliente = idcliente;
end;
Delimiter;

Delimiter $$
create procedure localizarcorretor(idcorretor int)
begin
	select * from corretor where id_corretor = idcorretor;
end;
Delimiter;

Delimiter $$
create procedure localizaraluguel(idaluguel int)
begin
	select * from aluguel where id_aluguel = idaluguel;
end;
Delimiter;

Delimiter $$
create procedure inserir_imovel(
in i_nome varchar(45),
i_categoria enum('Casa', 'Apartamento', 'Loft', 'Studio', 'Flat', 'Kitnet', 'Terreno'),
i_endereco varchar(60),
i_bairro varchar(25),
i_valor_aluguel decimal(10,2),
i_disponibilidade enum('Disponivel', 'Indisponivel'),
i_pkid_cliente int)
begin 
	insert into imoveis (nome_imovel,categoria,endereco,bairro,valor_aluguel,disponibilidade,pkid_cliente) values (i_nome, i_categoria, i_endereco, i_bairro, i_valor_aluguel, i_disponibilidade, i_pkid_cliente);
end;
Delimiter;

Delimiter $$
create procedure inserir_aluguel(
a_fcodfkcod_imovel int,
a_inquilino int,
a_fkid_corretor int,
a_data_inicio date,
a_data_fim date,
a_valor_final decimal(10,2),
a_status_aluguel enum('Disponivel','Indisponivel'))
begin
	insert into aluguel (fkcod_imovel, inquilino, fkid_corretor, data_inicio, data_fim, valor_final, status_aluguel) values (a_fcodfkcod_imovel, a_inquilino, a_fkid_corretor, a_data_inicio, a_data_fim, a_valor_final, a_status_aluguel);
end;
Delimiter;

Delimiter $$
create procedure inserir_cliente(
c_nome_cliente varchar(45),
c_cpf_ou_cnpj varchar(20),
c_telefone varchar(20),
c_email varchar(45),
c_tipo_cliente varchar(35))
begin 
	insert into cliente (nome_cliente, cpf_cnpj, telefone, email, tipo_cliente) values (c_nome_cliente, c_cpf_ou_cnpj, c_telefone, c_email, c_tipo_cliente);
end;
Delimiter;

Delimiter $$
create procedure inserir_corretor(
c_nome_corretor varchar(45),
c_creci varchar(20),
c_telefone varchar(20),
c_email varchar(30))
begin
	insert into corretor (nome_corretor, creci, telefone, email) values (c_nome_corretor, c_creci, c_telefone ,c_email);
end;
Delimiter;

Delimiter $$
create procedure inserir_proprietario(
c_nome_p varchar(45),
c_endereco varchar(20),
c_telefone varchar(20),
c_email varchar(30))
begin
	insert into proprietario (nome_corretor, creci, telefone, email) values (c_nome_proprietario, c_endereco, c_telefone ,c_email);
end;
Delimiter;

create table historico_cliente
(id_hist_cliente int auto_increment primary key,
hist_nome_cliente varchar(45),
hist_cpf_ou_cnpj varchar(20) not null,
hist_telefone varchar(20) not null,
usuario varchar(20) not null,
acao varchar(20) not null,
data_acao datetime not null);

create table historico_aluguel
(id_hist_aluguel int auto_increment primary key,
hist_id_aluguel int not null,
hist_fkcod_imovel int not null,
hist_inquilino int not null,
fkid_corretor int not null,
usuario varchar(20) not null,
acao varchar(20) not null,
data_acao datetime not null);

create table historico_corretor
(id_hist_corretor int auto_increment primary key,
hist_nome_corretor varchar(45) not null,
hist_creci varchar(20) not null,
usuario varchar(20) not null,
acao varchar(20) not null,
data_acao datetime not null);

create table historico_imovel
(id_hist_imovel int auto_increment primary key,
hist_nome_imovel varchar(45) not null,
hist_cod_imovel varchar(20) not null,
pkid_proprietario int not null,
usuario varchar(20) not null,
acao varchar(20) not null,
data_acao datetime not null);

create table historico_proprietario
(id_hist_prop int auto_increment primary key,
hist_nome_prop varchar(45) not null,
hist_id_prop int not null,
hist_telefone_prop varchar(20),
usuario varchar(20) not null,
acao varchar(20) not null,
data_acao datetime not null);

Delimiter $$
create trigger historico_insert_aluguel after insert on aluguel for each row
begin
	insert into historico_aluguel (hist_id_aluguel, hist_fkcod_imovel, hist_inquilino, fkid_corretor, usuario, acao, data_acao) values (new.id_aluguel, new.fkcod_imovel, new.inquilino, new.fkid_corretor, user(), 'insert()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_delete_aluguel after delete on aluguel for each row
begin
	insert into historico_aluguel (hist_id_aluguel, hist_fkcod_imovel, hist_inquilino, fkid_corretor, usuario, acao, data_acao) values (old.id_aluguel, old.fkcod_imovel, old.inquilino, old.fkid_corretor, user(), 'delete()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_insert_cliente after insert on cliente for each row
begin
	insert into historico_cliente (hist_nome_cliente, hist_cpf_ou_cnpj, hist_telefone, usuario, acao, data_acao) values (new.nome_cliente, new.cpf_ou_cnpj, new.telefone, user(), 'insert()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_delete_cliente after delete on cliente for each row
begin
	insert into historico_cliente (hist_nome_cliente, hist_cpf_ou_cnpj, hist_telefone, usuario, acao, data_acao) values (old.nome_cliente, old.cpf_ou_cnpj, old.telefone, user(), 'delete()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_insert_corretor after insert on corretor for each row
begin
	insert into historico_corretor (hist_nome_corretor, hist_creci, usuario, acao, data_acao) values (new.nome_corretor, new.creci, user(), 'insert()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_delete_corretor after delete on corretor for each row
begin
	insert into historico_corretor (hist_nome_corretor, hist_creci, usuario, acao, data_acao) values (old.nome_corretor, old.creci, user(), 'delete()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_insert_imoveis after insert on imoveis for each row
begin
	insert into historico_imovel (hist_nome_imovel, hist_cod_imovel, pkid_proprietario, usuario, acao, data_acao) values (new.nome_imovel, new.cod_imovel, new.pkid_proprietario ,user(), 'insert()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_delete_imoveis after delete on imoveis for each row
begin
	insert into historico_imovel (hist_nome_imovel, hist_cod_imovel, pkid_proprietario, usuario, acao, data_acao) values (old.nome_imovel, old.cod_imovel, old.pkid_proprietario ,user(), 'delete()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_insert_proprietario after insert on proprietario for each row
begin
	insert into historico_proprietario (hist_nome_prop,  hist_id_prop, hist_telefone_prop, usuario, acao, data_acao) values (new.nome_proprietario, new.id_proprietario, new.telefone ,user(), 'insert()', now());
end;
Delimiter;

Delimiter $$
create trigger historico_delete_proprietario after delete on proprietario for each row
begin
	insert into historico_proprietario (hist_nome_prop,  hist_id_prop, hist_telefone_prop, usuario, acao, data_acao) values (old.nome_proprietario, old.id_proprietario, old.telefone ,user(), 'delete()', now());
end;
Delimiter;

INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 1', '93405372742', '(86)97294-7355', 'cliente1@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 2', '38627420277', '(38)91721-3672', 'cliente2@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 3', '63735688552', '(34)99697-2703', 'cliente3@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 4', '68843053555', '(86)98036-8571', 'cliente4@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 5', '65846594419', '(44)90170-9021', 'cliente5@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 6', '15538431804', '(44)94290-8256', 'cliente6@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 7', '18329718415', '(27)96512-5874', 'cliente7@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 8', '36143845231', '(38)92199-3095', 'cliente8@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 9', '54230908976', '(21)98677-2695', 'cliente9@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 10', '40158259145', '(57)96801-9251', 'cliente10@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 11', '47862781659', '(42)93033-7452', 'cliente11@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 12', '19139909445', '(27)98721-5374', 'cliente12@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 13', '12302367696', '(21)99201-8057', 'cliente13@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 14', '72768076896', '(11)97376-1185', 'cliente14@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 15', '35825272114', '(96)97438-9010', 'cliente15@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 16', '36355902738', '(25)91424-4935', 'cliente16@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 17', '93395156673', '(95)95031-6282', 'cliente17@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 18', '77033571070', '(75)99118-8261', 'cliente18@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 19', '13634957002', '(15)93571-9582', 'cliente19@example.com', 'Pessoa Física');
INSERT INTO cliente (nome_cliente, cpf_ou_cnpj, telefone, email, tipo_cliente) VALUES ('Cliente 20', '37619972887', '(39)98755-1477', 'cliente20@example.com', 'Pessoa Física');

DELETE FROM cliente WHERE id_cliente = 1;
DELETE FROM cliente WHERE id_cliente = 2;
DELETE FROM cliente WHERE id_cliente = 3;
DELETE FROM cliente WHERE id_cliente = 4;
DELETE FROM cliente WHERE id_cliente = 5;

INSERT INTO proprietario (nome_proprietario, endereco, telefone, email) VALUES ('Proprietario 1', 'Rua Proprietario 1, 10', '(99)95434-7034', 'proprietario1@example.com');

DELETE FROM proprietario WHERE id_proprietario = 1;
DELETE FROM proprietario WHERE id_proprietario = 2;
DELETE FROM proprietario WHERE id_proprietario = 3;
DELETE FROM proprietario WHERE id_proprietario = 4;
DELETE FROM proprietario WHERE id_proprietario = 5;
