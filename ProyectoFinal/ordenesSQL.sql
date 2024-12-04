-- Active: 1731017031363@@127.0.0.1@3306@ordenesSQL
DROP DATABASE ordenesSQL

CREATE DATABASE ordenesSQL

USE ordenesSQL

/* #!#!#!#!#!#!#!#!#! TABLAS #!#!#!#!#!#!#!#!#!*/
create table cliente(
    numero int PRIMARY KEY AUTO_INCREMENT,
    nombreFiscal varchar(50) not null,
    nombreCont varchar(50) not null,
    primApellido varchar(25) not null,
    segApellido varchar(25) not null,
    email varchar (50) not null,
    numTel varchar (25) not null
)

create table rol(
    codigo varchar (5) PRIMARY KEY,
    nombre varchar (20) not null
)

create table puesto(
    clave varchar (5) PRIMARY KEY,
    nombre varchar (20) not null
)

create table estado_orden(
    codigo varchar (5) PRIMARY KEY,
    descripcion varchar (20) not null
)

create table ingredientes(
    codigo varchar (5) PRIMARY KEY,
    descripcion varchar (150) not null
)

create table ingr_activo(
    codigo varchar (5) PRIMARY KEY,
    nomIngrediente varchar (50) not null
)

create table mat_empaque(
    codigo varchar (5) PRIMARY KEY,
    nombre varchar (100) not null
)

create table tipo_presentacion(
    codigo varchar (6) PRIMARY KEY,
    nombre varchar (20) not null,
    presentacion int not null
)

create table tipo_producto(
    codigo varchar (5) PRIMARY KEY,
    nombre varchar (30) not null
)

create table usuario(
    numero int PRIMARY KEY AUTO_INCREMENT,
    nombreUsuario varchar (30) not null,
    contrasenia varchar (300) not null,
    rol varchar (5),
    foreign key (rol) references rol(codigo)
)

create table empleado(
    numero int PRIMARY KEY AUTO_INCREMENT,
    nombre varchar (30) not null,
    primApellido varchar (30) not null,
    segApellido varchar (30) null,
    email varchar (50) not null,
    usuario int,
    puesto varchar (5),
    foreign key (usuario) references usuario(numero),
    foreign key (puesto) references puesto(clave)
)

create table producto(
    codigo int PRIMARY KEY AUTO_INCREMENT,
    nombre varchar (50) not null,
    nombreGenerico varchar (100) not null,
    empleado int,
    tipo_producto varchar (5),
    tipo_presentacion varchar (6),
    foreign key (empleado) references empleado(numero),
    foreign key (tipo_producto) references tipo_producto(codigo),
    foreign key (tipo_presentacion) references tipo_presentacion(codigo)
)

create table pedido(
    numero int PRIMARY KEY AUTO_INCREMENT,
    fecha date not null,
    fechaEntrega date not null,
    cantProducto int not null,
    producto int,
    cliente int,
    empleado int,
    foreign key (producto) references producto(codigo),
    foreign key (cliente) references cliente(numero),
    foreign key (empleado) references empleado(numero)
)

create table orden(
    numero int PRIMARY KEY AUTO_INCREMENT,
    fechaOrden date not null,
    fechaInicio date null,
    fechaFinal date null,
    pesoFinalFormu decimal(10,2),
    pesoFinalBlend decimal(10,2),
    estado_orden varchar (5),
    pedido int,
    empleado int,
    producto int,
    foreign key (estado_orden) references estado_orden(codigo),
    foreign key (pedido) references pedido(numero),
    foreign key (empleado) references empleado(numero),
    foreign key (producto) references producto(codigo)
)

create table lote(
    numero int PRIMARY KEY,
    cantUnidades int not null,
    cantTotalTabCap decimal(10,2),
    fechaElab date not null,
    fechaCad date not null,
    producto int,
    foreign key (producto) references producto(codigo)
)

create table tipo_embalaje(
    orden int,
    mat_empaque varchar (5),
    cantidad int not null,
    PRIMARY KEY(orden, mat_empaque),
    foreign key (orden) references orden(numero),
    foreign key (mat_empaque) references mat_empaque(codigo)
)

create table mat_prima(
    ingredientes varchar (5),
    orden int,
    cantidadMat float not null,
    PRIMARY KEY(ingredientes, orden),
    foreign key (orden) references orden(numero),
    foreign key (ingredientes) references ingredientes(codigo)
)

create table mat_prima_activa(
    ingr_activo varchar (5),
    orden int,
    cantidadMatAct float not null,
    PRIMARY KEY(ingr_activo, orden),
    foreign key (ingr_activo) references ingr_activo(codigo),
    foreign key (orden) references orden(numero)
)

create table formula(
    producto int,
    ingredientes varchar (5),
    cantidadIng float not null,
    uniMed varchar (20) not null,
    PRIMARY KEY(producto, ingredientes),
    foreign key (producto) references producto(codigo),
    foreign key (ingredientes) references ingredientes(codigo)
)

create table form_act(
    ingr_activo varchar (5),
    producto int,
    cantidadAct float not null,
    uniMed varchar (20) not null,
    PRIMARY KEY(ingr_activo, producto),
    foreign key (ingr_activo) references ingr_activo(codigo),
    foreign key (producto) references producto(codigo)
)

create table emp_producto(
    producto int,
    mat_empaque varchar (5),
    cantMatxProd int not null,
    PRIMARY KEY(mat_empaque, producto),
    foreign key (producto) references producto(codigo),
    foreign key (mat_empaque) references mat_empaque(codigo)
)

/* _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- INSERTS _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- */
insert into cliente (numero, nombreFiscal, nombreCont, primApellido, segApellido, email, numTel) values
(1, 'Collins', 'Carlos Ernesto', 'González', 'Martínez', 'carlosGM@gmail.com', '664 456 2589'),
(2, 'PiSA', 'Ana Karen', 'Rodríguez', 'López', 'anitaLavaLaTina@gmail.com', '664 147 4569'),
(3, 'Maver', 'Diego', 'Pérez', 'Carcía', 'diegoPCa@gmail.com', '664 789 1456'),
(4, 'Bayer', 'Laura', 'Fernández', 'Ruiz', 'lauraFer@gmail.com', '664 963 1547'),
(5, 'B life', 'Javier Ivan', 'Sánchez', 'Herrera', 'javiSh123@gmail.com', '663 951 7536')

insert into rol (codigo, nombre) values
("admin", "Administrador"),
("basic", "Basico")

insert into puesto (clave, nombre) values
('GEREN', 'Gerente'),
('SUPER','Supervisor'),
('OPER', 'Operador')

insert into estado_orden (codigo, descripcion) values
('FINAL', 'Finalizada'),
('ENPRO', 'En proceso'),
('SININ', 'Sin iniciar'),
('CANCE', 'Cancelada'),
('PAUSA', 'Pausada')

insert into ingredientes (codigo, descripcion) values
('CELMC', 'celulosa micro cristalina'),
('CREMA', 'crema'),
('HPRML', 'hipromelosa'),
('CTRDM', 'citrato de magnesio'),
('MALTO', 'maltodextrina'),
('CREAT', 'monohidrato de creatina micronizada')

insert into ingr_activo (codigo, nomIngrediente) values
('IBUP', 'Ibuprofeno'),
('ACISA', 'Acido salicilico'),
('AMOXI', 'Amoxicicilina'),
('ACICL', 'Ácido Clavulánico'),
('CAFAL', 'Cefalexina'),
('CLIND', 'Clindamicina'),
('LORAT', 'Loratadina')

insert into mat_empaque (codigo, nombre) values
('BLR10', 'Blister redondo 10'),
('BLC10', 'Blister capsulas 10'),
('BLC08', 'Blister capsulas 8'),
('CJ01', 'Cajas plegadizas Dolprofen'),
('CJ02', 'Cajas plegadizas Amoxiclav'),
('CJ03', 'Cajas plegadizas Naxifelar'),
('CJ04', 'Cajas plegadizas Indacil'),
('CJ05', 'Cajas plegadizas Clarityne'),
('FR050', 'FPH-50/R33'),
('ALGOD', 'Algodon'),
('ET02', 'Etiqueta Amoxiclav'),
('ET06', 'Etiqueta Citrate Mag'),
('ET07', 'Etiqueta Creatine'),
('SILIC', 'Silicas'),
('500CC', 'Bote negro 500ml'),
('B20OZ', 'Bote de 20 oz'),
('T500C', 'Tapa de Bote negro 500ml'),
('T20OZ', 'Tapa de Bote de 20 oz'),
('C05GR', 'Cuchara de 5 gramos'),
('CAPSU', 'capsula gelatina')

insert into tipo_presentacion (codigo, nombre, presentacion) values
('TB10', 'tabletas', 10),
('TB15', 'tabletas', 15),
('TB20', 'tabletas', 20),
('CP16', 'capsulas', 16),
('CP20', 'capsulas', 20),
('CP240', 'capsulas', 240),
('CREMA', 'crema', 30),
('GEL', 'gel', 30),
('PL600', 'polvo', 600),
('SUSPE', 'suspension', 200)

insert into tipo_producto (codigo, nombre) values
('SUPLE', 'Suplemento Alimenticio'),
('FARMA', 'Farmaceutico')

insert into usuario (numero, nombreUsuario, contrasenia, rol) values
(3001, 'amedina', 123456, 'ADMIN'),
(3002, 'mramirez', 789123, 'ADMIN'),
(3003, 'adiaz', 456789, 'BASIC'),
(3004, 'dmartinez', 159753, 'BASIC'),
(3005, 'mcalamaro', 753951, 'BASIC')

insert into empleado (numero, nombre, primApellido, segApellido, email, usuario, puesto) values
(1, 'Alan Oswaldo', 'Medina', 'Becerra', 'AlanMedina@hotmail.com', 3001, 'GEREN'),
(2, 'Marcos', 'Ramirez', 'Navarro', 'MarcosRamirez@gmail.com', 3002, 'SUPER'),
(3, 'Alejandro', 'Diaz', 'Cervantes Amieva', 'AlejandroDiaz@icloud.com', 3003, 'OPER'),
(4, 'Diana', 'Martinez', 'Perez', 'DianaMartinez@gmail.com', 3004, 'OPER'),
(5, 'Mateo', 'Calamaro', 'Ortiz', 'MateoCalamaro@yahoo.com', 3005, 'OPER')

insert into producto (codigo, nombre, nombreGenerico, empleado, tipo_producto, tipo_presentacion) values
(1, 'Dolprofen 400 mg', 'Ibuprofeno', 1, 'FARMA', 'TB10'),
(2, 'Amoxiclav 500 mg', 'Amoxicicilina, Ácido Clavulánico', 1, 'FARMA', 'TB15'),
(3, 'Naxifelar 500 mg', 'Cefalexina', 2, 'FARMA', 'CP20'),
(4, 'Indacil 300 mg', 'Clindamicina', 2, 'FARMA', 'CP16'),
(5, 'Clarityne 10 mg', 'Loratadina', 1, 'FARMA', 'TB10'),
(6, 'Citrate Mag', 'Citrato de Magnesio', 1, 'SUPLE', 'CP240'),
(7, 'Creatine 600 gr', 'Monohydrate', 2, 'SUPLE', 'PL600')

insert into pedido (numero, fecha, fechaEntrega, cantProducto, producto, cliente, empleado) values
(1, '2023-01-01', '2023-01-10', 100, 1, 1, 1),
(2, '2023-02-01', '2023-02-10', 150, 2, 2, 1),
(3, '2023-03-01', '2023-03-10', 200, 3, 2, 2),
(4, '2023-04-01', '2023-04-10', 100, 4, 3, 2),
(5, '2023-05-01', '2023-05-10', 150, 5, 4, 1),
(6, '2023-06-01', '2023-06-10', 100, 6, 5, 1),
(7, '2023-07-01', '2023-07-10', 50, 7, 5, 2)

insert into orden (numero, fechaOrden, fechaInicio, fechaFinal, pesoFinalFormu, pesoFinalBlend, estado_orden, pedido, empleado, producto) values
(1, '2023-01-01', '2023-01-02', '2023-01-09',1 ,1000 ,'FINAL', 1, 1, 1),
(2, '2023-02-01', '2023-02-02', '2023-02-09',1 ,2250 ,'FINAL', 2, 1, 2),
(3, '2023-03-01', '2023-03-02', '2023-03-09',1 ,4000 ,'FINAL', 3, 2, 3),
(4, '2023-04-01', '2023-04-02', '2023-04-09',1 ,1600 ,'FINAL', 4, 2, 4),
(5, '2023-05-01', '2023-05-02', NULL,1 ,1500 ,'ENPRO', 5, 1, 5),
(6, '2023-06-01', NULL, NULL,0.8 ,19200 ,'SININ', 6, 1, 6),
(7, '2023-07-01', NULL, NULL,1 ,30000 ,'SININ', 7, 2, 7)

insert into lote (numero, cantUnidades, cantTotalTabCap, fechaElab, fechaCad, producto) values
(112023, 100, 1000.00, '2023-01-02', '2024-01-01', 1),
(222023, 150, 2250.00, '2023-02-02', '2024-02-01', 2),
(332023, 200, 4000.00, '2023-03-02', '2024-03-01', 3),
(442023, 100, 1600.00, '2023-04-02', '2024-04-01', 4),
(552023, 150, 1500.00, '2023-05-02', '2024-05-01', 5),
(662023, 100, 24000.00, '2023-06-02', '2024-06-01', 6),
(772023, 50, 30000.00, '2023-07-02', '2024-07-01', 7)

insert into tipo_embalaje (orden, mat_empaque, cantidad) values
(1, 'BLR10', 100),
(1, 'CJ01', 100),
(2, 'CJ02', 150),
(2, 'ET02', 150),
(2, 'FR050', 150),
(2, 'SILIC', 150),
(2, 'ALGOD', 450),
(3, 'CJ03', 200),
(3, 'BLC10', 400),
(3, 'BLC08', 4000),
(4, 'CJ04', 100),
(4, 'BLC08', 200),
(4, 'BLC10', 1600),
(5, 'BLR10', 150),
(5, 'CJ05', 150),
(6, '500CC', 100),
(6, 'ET06', 100),
(6, 'SILIC', 100),
(6, 'ALGOD', 500),
(7, 'B20OZ', 50),
(7, 'T20OZ', 50),
(7, 'ET07', 50),
(7, 'C05GR', 50)

insert into mat_prima(ingredientes, orden, cantidadMat) values
('CELMC', 1, 600.00),
('HPRML', 2, 843.75),
('HPRML', 3, 2000.00),
('HPRML', 4, 1120.00),
('CELMC', 5, 1485.00),
('CTRDM', 6, 3240.00),
('MALTO', 6, 15960.00),
('CREAT', 7, 30000.00)

insert into mat_prima_activa(ingr_activo, orden, cantidadMatAct) values
('IBUP', 1, 400.00),
('AMOXI', 2, 1125.00),
('ACICL', 2, 281.25),
('CAFAL', 3, 2000.00),
('CLIND', 4, 480.00),
('LORAT', 5, 15.00)

insert into formula (producto, ingredientes, cantidadIng, uniMed) values
(1, 'CELMC', 0.6, 'gr'),
(2, 'HPRML', 0.375, 'gr'),
(3, 'HPRML', 0.5, 'gr'),
(4, 'HPRML', 0.7, 'gr'),
(5, 'CELMC', 0.99, 'gr'),
(6, 'CTRDM', 0.135, 'gr'),
(6, 'MALTO', 0.665, 'gr'),
(7, 'CREAT', 1, 'gr')

insert into form_act (ingr_activo, producto, cantidadAct, uniMed) values
('IBUP', 1, 0.4, 'gr'),
('AMOXI', 2, 0.5, 'gr'),
('ACICL', 2, 0.125, 'gr'),
('CAFAL', 3, 0.5, 'gr'),
('CLIND', 4, 0.3, 'gr'),
('LORAT', 5, 0.01, 'gr')

insert into emp_producto(producto, mat_empaque, cantMatxProd) values
(1, 'BLR10', 1),
(1, 'CJ01', 1),
(2, 'CJ02', 1),
(2, 'FR050', 1),
(2, 'ALGOD', 3),
(2, 'ET02', 1),
(2, 'SILIC', 1),
(3, 'CJ03', 1),
(3, 'BLC10', 2),
(3, 'CAPSU', 20),
(4, 'CJ04', 1),
(4, 'BLC08', 2),
(4, 'CAPSU', 16),
(5, 'BLR10', 1),
(5, 'CJ05', 1),
(6, '500CC', 1),
(6, 'ET06', 1),
(6, 'SILIC', 1),
(6, 'ALGOD', 5),
(6, 'CAPSU', 240),
(7, 'B20OZ', 1),
(7, 'T20OZ', 1),
(7, 'ET07', 1),
(7, 'C05GR', 1)




/* _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- VISTAS DE LA ORDEN DE PRODUCCION PDF "FÁRMACOS" _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- */

/*------------------------------------------------------------------------------------------------------------*/
--ordenInfor view--


--ordenInfor view--
CREATE VIEW vw_PRODORD_info AS
    SELECT DISTINCT 
        o.numero AS noOrden,
        l.cantUnidades AS Lot_Size,
        CONCAT(l.cantTotalTabCap, ' ', tpre.nombre) AS Total_CapsTabs,
        CONCAT(SUM(mp.cantidadMat) + 
            (SELECT SUM(mpa.cantidadMatAct) 
                FROM mat_prima_activa AS mpa 
                WHERE mpa.orden = o.numero)) AS Total_Blend,
        p.nombre AS TradeMark,
        p.nombreGenerico AS ChemicalName,
        CONCAT(tpre.presentacion, ' ', tpre.nombre) AS Presentation,
        ia.nomIngrediente AS ActiveIngredients,
        l.numero AS Lot,
        DATE_FORMAT(l.fechaCad, "%D,%M,%Y") AS ExpDate, 
        CONCAT(o.pesoFinalBlend, ' ', f.uniMed) AS Blend, 
        CONCAT(o.pesoFinalFormu, ' ', f.uniMed) AS PesForm
    FROM orden AS o 
    INNER JOIN producto AS p ON o.producto = p.codigo
    INNER JOIN lote AS l ON l.producto = p.codigo
    INNER JOIN tipo_presentacion AS tpre ON p.tipo_presentacion = tpre.codigo
    INNER JOIN formula AS f ON f.producto = p.codigo
    INNER JOIN form_act AS fa ON fa.producto = p.codigo
    INNER JOIN ingr_activo AS ia ON fa.ingr_activo = ia.codigo
    INNER JOIN mat_prima_activa AS mpa ON mpa.orden = o.numero
    INNER JOIN mat_prima AS mp ON mp.orden = o.numero
GROUP BY o.numero, l.cantUnidades, l.cantTotalTabCap, tpre.nombre, p.nombre, p.nombreGenerico, tpre.presentacion,
         ia.nomIngrediente, l.numero, l.fechaCad, f.uniMed, o.pesoFinalBlend, o.pesoFinalFormu;



    select * from vw_PRODORD_info
    where noOrden = 1 and Lot = (select CONCAT((p.numero), MONTH(o.fechaOrden), YEAR(o.fechaOrden))
                                from pedido as p
                                INNER JOIN orden as o on o.pedido = p.numero
                                where p.numero = 1)

                                
/*------------------------------------------------------------------------------------------------------------*/
--FormulsOrden view--


--FormulsOrden view--
CREATE VIEW vw_PRODORD_formulsOrden as
    SELECT DISTINCT
        o.numero as noOrden,
        i.descripcion as Ingredients,
        CONCAT(TRUNCATE(SUM(f.cantidadIng), 3),' ',f.uniMed) as Ingredients_Amount
    FROM orden as o
    INNER JOIN producto as p on o.producto = p.codigo
    INNER JOIN formula as f on f.producto = p.codigo
    INNER JOIN ingredientes as i on f.ingredientes = i.codigo
    INNER JOIN mat_prima as mp on o.numero = mp.orden
    GROUP BY o.numero, i.descripcion, f.uniMed, mp.cantidadMat, f.cantidadIng



/* -------------------------------MATERIA PRIMA ING----------------------------------------------------------- */


CREATE VIEW vw_PRODORD_formuMatPrima as
    SELECT DISTINCT
        o.numero as noOrden,
        i.descripcion as Ingredients,
         mp.cantidadMat as totalIngredient
    FROM orden as o
    INNER JOIN producto as p on o.producto = p.codigo
    INNER JOIN mat_prima as mp on o.numero = mp.orden
    INNER JOIN ingredientes as i on mp.ingredientes = i.codigo
    GROUP BY o.numero, i.descripcion, mp.cantidadMat


/*------------------------------------------------------------------------------------------------------------*/
--FormulsActiveOrden view--



CREATE VIEW vw_PRODORD_formulsActive as
SELECT DISTINCT
        o.numero as noOrden,
        ia.nomIngrediente as Active_Ingredients,
        CONCAT(TRUNCATE(SUM(fa.cantidadAct), 3),' ',fa.uniMed) as ActiveIngrs_Amount        
    FROM orden as o
    INNER JOIN producto as p on o.producto = p.codigo
    INNER JOIN formula as f on f.producto = p.codigo
    INNER JOIN form_act as fa on fa.producto = p.codigo
    INNER JOIN ingr_activo as ia on fa.ingr_activo = ia.codigo
    GROUP BY o.numero,  ia.nomIngrediente, fa.cantidadAct, fa.uniMed


    
/* -------------------------------MATERIA PRIMA ING----------------------------------------------------------- */

CREATE VIEW vw_PRODORD_formuMatPrimaAct as
    SELECT DISTINCT
        o.numero as noOrden,
        i.nomIngrediente as Ingredients,
         mp.cantidadMatAct as totalIngredient
    FROM orden as o
    INNER JOIN producto as p on o.producto = p.codigo
    INNER JOIN mat_prima_activa as mp on o.numero = mp.orden
    INNER JOIN ingr_activo as i on mp.ingr_activo = i.codigo
    GROUP BY o.numero, i.nomIngrediente, mp.cantidadMatAct



/*------------------------------------------------------------------------------------------------------------*/
--EmpaqueOrden view--

CREATE VIEW vw_PRODORD_empaqueOrden as
    SELECT DISTINCT
        o.numero as noOrden,
        me.nombre as Material,
        ep.cantMatxProd as FOR_UNIT,
        te.cantidad as T_per_Order,
        p.codigo as codProd
    FROM orden as o
    INNER JOIN tipo_embalaje as te on te.orden = o.numero
    INNER JOIN mat_empaque as me on te.mat_empaque = me.codigo
    INNER JOIN emp_producto as ep on ep.mat_empaque = me.codigo
    INNER JOIN producto as p on ep.producto = p.codigo



/* ---------------------------------------VISTAS SUPLEMENTOS ALIMENTICIOS---------------------------------------- */


CREATE VIEW vw_PRODORD_info_suple as
    SELECT DISTINCT o.numero as noOrden,
            l.cantUnidades as Lot_Size,
            CONCAT(l.cantTotalTabCap,' ',f.uniMed) as Total_Blend,
            p.nombre as TradeMark,
            p.nombreGenerico as ChemicalName,
            CONCAT(tpre.presentacion,' ',tpre.nombre) as Presentation,
            l.numero as Lot,
            DATE_FORMAT(l.fechaCad, "%D,%M,%Y") as ExpDate, 
            CONCAT(o.pesoFinalBlend,' ',f.uniMed) as Blend, 
            CONCAT(o.pesoFinalFormu,' ',f.uniMed) as PesForm
    FROM orden as o 
    INNER JOIN producto as p on o.producto = p.codigo
    INNER JOIN lote as l on l.producto = p.codigo
    INNER JOIN formula as f on f.producto = p.codigo
    INNER JOIN tipo_presentacion as tpre on p.tipo_presentacion = tpre.codigo
    INNER JOIN mat_prima as mp on mp.orden = o.numero 
    GROUP BY o.numero, l.cantUnidades,l.cantTotalTabCap,tpre.nombre,p.nombre,p.nombreGenerico,
    tpre.presentacion,l.numero,l.fechaCad



/* -----------------------------------------------------------PRODUCTO----------------------------------- */


CREATE VIEW vw_info_Prod as
    select p.codigo as codProd,
    p.nombre as tradeMark,
    p.nombreGenerico as chemicalName,
    tpr.nombre as typeProduct,
    tpr.codigo as typeProductCode,
    f.uniMed as measure
from producto as p
inner join tipo_producto as tpr on p.tipo_producto = tpr.codigo
inner join formula as f on f.producto = p.codigo



/* _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- CONSULTAS _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- */

select CONCAT(e.nombre,' ', e.primApellido,' ', e.segApellido) as Nombre, r.nombre as ROL
from empleado as e
inner join usuario as u on e.numero =  u.numero
inner join rol as r on u.rol = r.codigo
where r.codigo = 'admin'


select * from rol

    /* EMPLOYEES AND USERS */
select e.numero as NUMBER, u.nombreUsuario as USER, CONCAT(e.nombre,' ',e.primApellido,' ',e.segApellido) as NAME,
        e.email as EMAIL, r.nombre as ACCESS, p.nombre as PUESTO
from empleado as e
inner join usuario as u on e.usuario = u.numero
inner join rol as r on u.rol = r.codigo
inner join puesto as p on e.puesto = p.clave



    /*CUSTOMERS*/
SELECT numero as NUMBER, nombreFiscal as TRADE, CONCAT(nombreCont,' ',primApellido,' ',segApellido) as CONTACT, numTel as PHONE, email as EMAIL
FROM cliente


    /*PRODUCTS & FORMULATIONS*/
SELECT p.codigo as CODE, p.nombre as NAME, p.nombreGenerico as GENERIC, tp.nombre as TIPO, CONCAT(tpre.presentacion,', ',tpre.nombre) as PRESENTATION
FROM producto as p
INNER JOIN tipo_producto as tp on p.tipo_producto = tp.codigo
INNER JOIN tipo_presentacion as tpre on p.tipo_presentacion = tpre.codigo
ORDER BY p.codigo;


/* _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- VISTAS _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- */


    /* VISTA NUMERO 3 */
CREATE VIEW vw_mostrar_Clientes as 
    SELECT numero, nombreFiscal 
    FROM cliente

    /* VISTA NUMERO 4 */
CREATE VIEW vw_mostrar_Productos as 
    SELECT codigo, nombre
    FROM producto


    /* VISTA NUMERO 8 */
CREATE VIEW vw_mostrar_Puestos as 
    SELECT clave, nombre 
    FROM puesto


    /* VISTA NUMERO 9 */
CREATE VIEW vw_mostrar_rol as 
    SELECT codigo, nombre
    FROM rol



/* _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- STORAGE PROCEDURES _-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- */

DELIMITER $$
CREATE PROCEDURE SP_getInfoCus(
    IN num INT
)
BEGIN
    SELECT nombreFiscal AS taxname,
        nombreCont as contactname,
        primApellido AS surname,
        segApellido AS lastname,
        email AS email,
        numTel AS numTel
    FROM cliente
    WHERE numero = num;
END $$
        CALL SP_getInfoCus(?)


DELIMITER $$
CREATE PROCEDURE SP_getUserInfo(
    IN nombre varchar (40)
)
BEGIN
    SELECT e.nombre AS nombre,
            e.primApellido AS surname,
            e.segApellido AS lastname,
            u.nombreUsuario AS Usuario
            FROM empleado AS e
    INNER JOIN usuario AS u ON e.usuario = u.numero
    INNER JOIN puesto AS p ON e.puesto = p.clave 
    INNER JOIN rol AS r ON u.rol = r.codigo
    WHERE u.nombreUsuario = nombre;
END $$

CALL SP_getUserInfo(?)



DELIMITER $$
CREATE PROCEDURE SP_getEmpInfo(
    IN num INT
)
BEGIN
    SELECT e.nombre AS nombre,
            e.primApellido AS surname,
            e.segApellido AS lastname,
            e.email AS email,
            p.nombre AS Puesto,
            r.nombre AS Rol,
            u.nombreUsuario AS Usuario
    FROM empleado AS e
    INNER JOIN usuario AS u ON e.usuario = u.numero
    INNER JOIN puesto AS p ON e.puesto = p.clave 
    INNER JOIN rol AS r ON u.rol = r.codigo
    WHERE e.numero = num;
END $$

        CALL SP_getEmpInfo(2)


DELIMITER$$

CREATE PROCEDURE SP_show_Pedidos()
BEGIN
    SELECT p.numero as Number, CONCAT(c.nombreFiscal,' ',c.email,' ',c.numTel) as Information,
        pr.nombre as Product,
        p.cantProducto as UnitsQuantity,
        p.fecha as OrderDate
    FROM pedido as p
    INNER JOIN producto as pr on p.producto = pr.codigo
    INNER JOIN cliente as c on p.cliente = c.numero
    ORDER BY p.numero;
END $$
        CALL SP_show_Pedidos()


DELIMITER $$
CREATE PROCEDURE SP_show_EmpleadosyUsuarios()
BEGIN
    SELECT e.numero as NUMBER, u.nombreUsuario as USER,
            CONCAT(e.nombre,' ',e.primApellido,' ',e.segApellido) as NAME,
            e.email as EMAIL, r.nombre as ACCESS, p.nombre as POSITION
    FROM empleado as e
    INNER JOIN usuario as u on e.usuario = u.numero
    INNER JOIN rol as r on u.rol = r.codigo
    INNER JOIN puesto as p on e.puesto = p.clave
    ORDER BY e.numero;
END $$

        CALL SP_show_EmpleadosyUsuarios()

DELIMITER $$
CREATE PROCEDURE SP_show_Clientes()
BEGIN
    SELECT numero as NUMBER, nombreFiscal as TRADE,
        CONCAT(nombreCont,' ',primApellido,' ',segApellido) as CONTACT,
        numTel as PHONE, email as EMAIL
    FROM cliente;
END $$
        CALL SP_show_Clientes()

DELIMITER $$
CREATE PROCEDURE SP_show_Ordenes()
BEGIN
    SELECT 
        o.numero AS Number, 
        p.nombre AS CommercialName, 
        p.nombreGenerico AS GenericName,
        o.fechaOrden AS OrderDate, 
        COALESCE(DATE_FORMAT(o.fechaInicio, '%Y-%m-%d'), 'No establecida') AS StartDate,
        COALESCE(DATE_FORMAT(o.fechaFinal, '%Y-%m-%d'), 'No establecida') AS EndDate,
        tp.nombre AS TypeOfProduct, 
        pe.cantProducto AS UnitsQuantity,
        eo.descripcion AS Status
    FROM orden AS o 
    INNER JOIN producto AS p ON o.producto = p.codigo
    INNER JOIN tipo_producto AS tp ON p.tipo_producto = tp.codigo
    INNER JOIN pedido AS pe ON o.pedido = pe.numero
    INNER JOIN estado_orden AS eo ON o.estado_orden = eo.codigo
    ORDER BY o.numero;
END $$
        CALL SP_show_Ordenes()

DELIMITER $$
CREATE PROCEDURE SP_show_ProductosyFormu()
BEGIN
    SELECT p.codigo as CODE, p.nombre as NAME, p.nombreGenerico as GENERIC,
        tp.nombre as TYPE, CONCAT(tpre.presentacion,' ',tpre.nombre) as PRESENTATION
    FROM producto as p
    INNER JOIN tipo_producto as tp on p.tipo_producto = tp.codigo
    INNER JOIN tipo_presentacion as tpre on p.tipo_presentacion = tpre.codigo
    ORDER BY p.codigo;
END $$
    CALL SP_show_ProductosyFormu()


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------TRIGGERS PERRONES------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TRIGGER iniciarOrden


DELIMITER $$
CREATE TRIGGER iniciarOrden
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    INSERT INTO orden (numero, fechaOrden, fechaInicio, fechaFinal, pesoFinalFormu, pesoFinalBlend, estado_orden, pedido, empleado, producto)
    VALUES (new.numero, NEW.fecha, NULL, NULL, 0.0, 0.0, 'SININ', NEW.numero, NEW.empleado, NEW.producto);
END $$



DELIMITER $$
CREATE TRIGGER crearLote
AFTER INSERT ON orden
FOR EACH ROW
BEGIN
    DECLARE lote_numero VARCHAR(15);
    DECLARE cantUnidades INT;
    DECLARE contTotalTabCap DECIMAL(10,2);
    DECLARE presentacion INT;
    DECLARE tipo_producto VARCHAR(5);
    DECLARE nombre_presentacion VARCHAR(20);
    DECLARE fechaCad DATE;

    -- Obtener la cantidad de unidades del pedido
    SET cantUnidades = (SELECT cantProducto
                        FROM pedido
                        WHERE numero = NEW.pedido);

    -- Obtener la presentación y tipo del producto
    SET presentacion = (SELECT tp.presentacion
                        FROM producto AS p
                        INNER JOIN tipo_presentacion AS tp ON p.tipo_presentacion = tp.codigo
                        WHERE p.codigo = NEW.producto);

    SET tipo_producto = (SELECT p.tipo_producto
                        FROM producto AS p
                        INNER JOIN tipo_presentacion AS tp ON p.tipo_presentacion = tp.codigo
                        WHERE p.codigo =  NEW.producto);

    -- Obtener el nombre de la presentación
    SET nombre_presentacion = (SELECT tp.nombre
                               FROM producto AS p
                               INNER JOIN tipo_presentacion AS tp ON p.tipo_presentacion = tp.codigo
                               WHERE p.codigo = NEW.producto);

    -- Calcular contTotalTabCap
    IF nombre_presentacion = 'tabletas' OR nombre_presentacion = 'capsulas'
    THEN
        SET contTotalTabCap = presentacion * cantUnidades;
    ELSE
        SET contTotalTabCap = 0; -- O manejar de otra manera si no es tableta o cápsula
    END IF;

    -- Calcular el número de lote
    SET lote_numero =(select CONCAT((p.numero), MONTH(o.fechaOrden), YEAR(o.fechaOrden))
                                from pedido as p
                                INNER JOIN orden as o on o.pedido = p.numero
                                where p.numero = NEW.numero);
                                
    -- Calcular fechaCad según el tipo_producto
    IF tipo_producto = 'FARMA' THEN
        SET fechaCad = DATE_ADD(NEW.fechaOrden, INTERVAL 2 YEAR); -- 2 años de caducidad
    ELSEIF tipo_producto = 'SUPLE' THEN
        SET fechaCad = DATE_ADD(NEW.fechaOrden, INTERVAL 1 YEAR); -- 1 año de caducidad
    ELSE
        SET fechaCad = NULL; -- O manejar de otra manera si no es FARMA o SUPLE
    END IF;

    -- Insertar el nuevo lote
    INSERT INTO lote (numero, cantUnidades, cantTotalTabCap, fechaElab, fechaCad, producto)
    VALUES (lote_numero, cantUnidades, contTotalTabCap, NEW.fechaOrden, fechaCad, NEW.producto);
END $$



DELIMITER $$
CREATE TRIGGER calcuMatPrima
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_producto INT;
    DECLARE v_cantProducto INT;
    DECLARE v_presentacion INT;
    DECLARE v_ingrediente VARCHAR(5);
    DECLARE v_cantidadIng FLOAT;

    -- Cursor para recorrer los ingredientes del producto pedido
    DECLARE cursor_ingredientes CURSOR FOR
                                        SELECT f.ingredientes, f.cantidadIng, tp.presentacion
                                        FROM formula f
                                        INNER JOIN producto p ON p.codigo = f.producto
                                        INNER JOIN tipo_presentacion tp ON p.tipo_presentacion = tp.codigo
                                        WHERE p.codigo = NEW.producto;

    -- Handler para terminar el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Inicializa las variables con los datos del nuevo pedido
    SET v_producto = NEW.producto;
    SET v_cantProducto = NEW.cantProducto;

    -- Abre el cursor para recorrer los ingredientes
    OPEN cursor_ingredientes;

    read_loop: LOOP
        FETCH cursor_ingredientes INTO v_ingrediente, v_cantidadIng, v_presentacion;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calcula la cantidad total para cada ingrediente
        INSERT INTO mat_prima (ingredientes, orden, cantidadMat)
        VALUES (
            v_ingrediente, 
            (SELECT numero FROM orden WHERE pedido = NEW.numero), 
            v_cantidadIng * v_presentacion * v_cantProducto
        );
    END LOOP;

    -- Cierra el cursor
    CLOSE cursor_ingredientes;
END;


DELIMITER $$
CREATE TRIGGER calcuMatAct
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE ingreAct VARCHAR(5);
    DECLARE cantidadActi FLOAT;
    DECLARE present INT;
    
    -- Cursor para recorrer los ingredientes activos del producto relacionado
    -- con el pedido insertado
    DECLARE cursor_ingr_act CURSOR FOR
        SELECT fa.ingr_activo, fa.cantidadAct, tp.presentacion
        FROM form_act fa
        INNER JOIN producto p ON fa.producto = p.codigo
        INNER JOIN tipo_presentacion tp ON p.tipo_presentacion = tp.codigo
        WHERE p.codigo = NEW.producto;
    
    -- Handlers para controlar el cierre del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    -- Abrir cursor
    OPEN cursor_ingr_act;
    
    leer_ingr_act: LOOP
        FETCH cursor_ingr_act INTO ingreAct, cantidadActi, present;
        IF done THEN
            LEAVE leer_ingr_act;
        END IF;
        
        -- Calcular la cantidadMatAct y hacer la inserción en la tabla mat_prima_activa
        INSERT INTO mat_prima_activa (ingr_activo, orden, cantidadMatAct)
        VALUES ( ingreAct, (SELECT numero 
                                    FROM orden 
                                    WHERE pedido = NEW.numero),
                                    cantidadActi * present * NEW.cantProducto);
    END LOOP;
    
    -- Cerrar cursor
    CLOSE cursor_ingr_act;
END $$




DELIMITER $$
CREATE TRIGGER calcularMatEmpaque
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    -- Declarar variable para almacenar la cantidad del producto del pedido
    DECLARE cant_producto INT;
    -- Actualizar la tabla tipo_embalaje para cada material asociado al producto
    DECLARE done INT DEFAULT 0;
    DECLARE matEmpcode VARCHAR(5);
    DECLARE cantMatxProd INT;
    DECLARE qty float;

    -- Cursor para iterar sobre los materiales asociados al producto del pedido
    DECLARE cur CURSOR FOR
                        SELECT ep.mat_empaque, ep.cantMatxProd
                        FROM emp_producto ep
                        WHERE ep.producto = NEW.producto;

    -- Controlador de excepciones para cerrar el cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

     -- Asignar la cantidad de producto del pedido a la variable
    SET cant_producto = NEW.cantProducto;

    OPEN cur;
    -- Iterar a través de cada material y actualizar la cantidad en tipo_embalaje
    read_loop: LOOP
        FETCH cur INTO matEmpcode, cantMatxProd;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

    SET qty = cantMatxProd * cant_producto;

        -- Insertar el material y su cantidad calculada en tipo_embalaje
        INSERT INTO tipo_embalaje (orden, mat_empaque, cantidad)
        VALUES (NEW.numero, matEmpcode, qty );

    END LOOP;

    CLOSE cur;
END$$



DELIMITER $$
CREATE TRIGGER calcularPesoFinalFormula
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE total FLOAT;
    DECLARE cantFormu FLOAT;
    DECLARE cantFormAct FLOAT;
    DECLARE tipo_prod VARCHAR (5);

        SET tipo_prod = (SELECT pr.tipo_producto
                            FROM pedido as p
                            INNER JOIN producto as pr on p.producto = pr.codigo
                            WHERE p.numero = new.numero);

        SET cantFormu = (SELECT TRUNCATE (SUM(cantidadIng), 3)
                                    FROM formula
                                    WHERE producto = NEW.producto);

        SET cantFormAct = (SELECT TRUNCATE (SUM(cantidadAct), 3)
                            FROM form_act
                            WHERE producto = NEW.producto);

    IF tipo_prod = 'SUPLE' THEN
        SET total = cantFormu;
    ELSEIF tipo_prod = 'FARMA' THEN
        SET total = cantFormAct + cantFormu;
    END IF;

    -- Actualizar el campo pesoFinalForm en la tabla orden
    UPDATE orden
    SET pesoFinalFormu = total
    WHERE numero = NEW.numero;
END $$



DELIMITER $$
CREATE TRIGGER calcularPesoFinalBlend
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    DECLARE tipo_prod VARCHAR(5);
    DECLARE total FLOAT;
    DECLARE cantMat FLOAT;
    DECLARE cantMatAct FLOAT;

    -- Obtener el tipo de producto de la orden (relacionado con el producto)
    SET tipo_prod = (SELECT tipo_producto
                    FROM producto
                    WHERE codigo = NEW.producto);

    -- Calcular la suma de la cantidad de material de la tabla mat_prima
    SET cantMat = (SELECT SUM(cantidadMat)
                    FROM mat_prima
                    WHERE orden = NEW.numero);

    -- Calcular la suma de la cantidad de material de la tabla mat_prima_activa
    SET cantMatAct = (SELECT SUM(cantidadMatAct)
                        FROM mat_prima_activa
                        WHERE orden = NEW.numero);

    -- Si el producto es FARMA, también sumamos la cantidad de material de mat_prima_activa
    IF tipo_prod = 'SUPLE' THEN
        SET total = cantMat;
    ELSEIF tipo_prod = 'FARMA' THEN

        SET total = cantMat + cantMatAct;
    END IF;

    -- Actualizar el campo pesoFinalBlend en la tabla orden
    UPDATE orden
    SET pesoFinalBlend = total
    WHERE numero = NEW.numero;
END $$


DELIMITER $$
CREATE TRIGGER FechaEstado
BEFORE UPDATE ON orden
FOR EACH ROW
BEGIN
    -- Lógica de fechaInicio para estado 'ENPRO'
    IF NEW.estado_orden = 'ENPRO' THEN
        SET NEW.fechaInicio = CURRENT_DATE;
    END IF;

    -- Lógica de fechaFinal para estados 'FINAL', 'CANCE' y 'PAUSA'
    IF NEW.estado_orden = 'FINAL' OR NEW.estado_orden = 'CANCE' THEN
        SET NEW.fechaFinal = CURRENT_DATE;
    ELSEIF NEW.estado_orden = 'PAUSA' THEN
        SET NEW.fechaFinal = '0000-00-00';
    END IF;
END $$

