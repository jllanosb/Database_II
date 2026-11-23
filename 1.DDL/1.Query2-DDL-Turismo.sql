/*
Base Datos para sector Turismo
------------------------------
Incluye Reservas, Clientes, Empleados, Transporte, Hospedaje
Lugares Turisticos, Proveedores ect.
*/

--USA BASE MODELO
use master;
go

--Validar existencia base de datos
IF DB_ID ('Turismo_JLLB') is not null
begin
	DROP DATABASE Turismo_JLLB;
	print 'Base de datos Turismo_JLLB Eliminada';
end
go

--Crear la base de datos
CREATE DATABASE Turismo_JLLB;
print 'Se ha creado la base de datos Turismo_JLLB';
go

--usar la base de datos creado
use Turismo_JLLB;
print 'Usando Turismo_JLLB';
go

--Crear esquema
if SCHEMA_ID(N'RRHH') is null
begin
	EXEC (N'Create Schema RRHH Authorization dbo;');
	print 'Esquema RRHH Creado';
end 
else
begin
	print 'Esquema RRHH existe';
end;
go

if SCHEMA_ID(N'Compras') is null
begin
	EXEC (N'Create Schema Compras Authorization dbo;');
	print 'Esquema Compras Creado';
end 
else
begin
	print 'Esquema Compras existe';
end;
go

if SCHEMA_ID(N'Ventas') is null
begin
	EXEC (N'Create Schema Ventas Authorization dbo;');
	print 'Esquema Ventas Creado';
end 
else
begin
	print 'Esquema Ventas existe';
end;
go

if SCHEMA_ID(N'UNC') is null
begin
	EXEC (N'Create Schema UNC Authorization dbo;');
	print 'Esquema UNC Creado';
end 
else
begin
	print 'Esquema UNC existe';
end;
go

if SCHEMA_ID(N'JLLB') is null
begin
	EXEC (N'Create Schema JLLB Authorization dbo;');
	print 'Esquema JLLB Creado';
end 
else
begin
	print 'Esquema JLLB existe';
end;
go
/*
Creacion de Tablas
-- Validar Existencia
-- Crear la Tabla
*/
-- Crear Tabla Pais
if OBJECT_ID('JLLB.Pais', 'U') is not null
begin
	Drop Table JLLB.pais;
	print 'La tabla JLLB.Pais Eliminada'; 
end
go

CREATE TABLE JLLB.Pais (
	--primera forma poner PK
	idpais int primary key identity(1,1),
	nombrepais varchar(40) not null,
	codigoiso varchar(3) not null, --PER, ARG, CHL, COL
	fecha_registro datetime default getdate(),
	constraint UQ_nombrepais
	UNIQUE (nombrepais),
	constraint UQ_codigoiso
	UNIQUE (codigoiso)
);
print 'La tabla jllb.Pais creada';
go

--crear tabla nacionalidad
if OBJECT_ID('JLLB.Nacionalidad', 'U') is not null
begin
	Drop Table JLLB.Nacionalidad;
	print 'La tabla JLLB.Nacionalidad Eliminada'; 
end
go

CREATE TABLE JLLB.Nacionalidad (
	idnacionalidad int identity(1,1),
	nomnacionalidad varchar(80) not null,
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_nacionalidad
	primary key (idnacionalidad),
	constraint UQ_nacionalidad
	UNIQUE (nomnacionalidad),
	constraint FK_pais_nacionalidad
	foreign key (idpais) References JLLB.pais (idpais)
);
print 'Tabla Nacionalidad Creada';
go

--Crear tabla region (Departamento)
if OBJECT_ID('JLLB.Region', 'U') is not null
begin
	Drop Table JLLB.Region;
	print 'La tabla JLLB.Region Eliminada'; 
end
go

CREATE TABLE JLLB.Region (
	idregion int identity (1,1),
	nomregion varchar (80) not null,
	codigoubigeo varchar(3) not null,--CAJ, LIM, CUS
	idpais int not null,
	fecha_registro datetime default getdate(),
	constraint PK_region primary key (idregion),
	constraint UQ_nomregion UNIQUE (nomregion),
	constraint FK_region_pais
	foreign key (idpais) References JLLB.Pais (idpais)
);
print 'Tabla Region Creada';
go

--Crear tabla subregion (Provincia)
if OBJECT_ID('JLLB.SubRegion', 'U') is not null
begin
	Drop Table JLLB.SubRegion;
	print 'La tabla JLLB.SubRegion Eliminada'; 
end
go

CREATE TABLE jllb.Subregion (
	idsubregion int identity(1,1),
	nomsubregion nvarchar(100) not null,
	codigo_ubigeo varchar(4) not null,
	idregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_subregion primary key (idsubregion),
	constraint FK_subregion_region
	foreign key (idregion)
	references jllb.region (idregion)
);
print 'Tabla Subregion creada';
go

--Crear tabla ciudad o distrito
if OBJECT_ID('JLLB.ciudad', 'U') is not null
begin
	Drop Table JLLB.Ciudad;
	print 'La tabla JLLB.Ciudad Eliminada'; 
end
go

CREATE TABLE JLLB.Ciudad (
	idciudad int identity(1,1),
	nomciudad varchar(80) not null,
	codigo_ubigeo varchar(6),
	idsubregion int not null,
	fecha_registro datetime default getdate(),
	constraint PK_ciudad primary key (idciudad),
	constraint FK_ciudad_subregion
	foreign key (idsubregion)
	References JLLB.Subregion (idsubregion)
);
print 'Tabla Ciudad creada';
go

--Crear tabla Tipo_documento
if OBJECT_ID('RRHH.TipoDocumento', 'U') is not null
begin
	Drop Table RRHH.TipoDocumento;
	print 'La tabla RRHH.TipoDocumento Eliminada'; 
end
go

CREATE TABLE RRHH.TipoDocumento(
	idtipodocumento int identity(1,1),
	nombredoc varchar(50) not null,
	abreviatura char(10) not null,
	fecha_registro datetime default getdate(),
	constraint PK_tipodocumento
	primary key (idtipodocumento),
	constraint UQ_nombredoc UNIQUE (nombredoc),
	constraint UQ_abreviatura UNIQUE (abreviatura)
);
print 'Tabla TipoDocumento Creado';
go

--Crear tabla Persona 
if OBJECT_ID('RRHH.Persona', 'U') is not null
begin
	Drop Table RRHH.Persona;
	print 'La tabla RRHH.Persona Eliminada'; 
end
go

CREATE TABLE RRHH.Persona (
	idpersona int identity(1,1),
	tipo_persona char(1) not null --N: Natural,J:Juridica
	constraint CHK_tipo_persona
	CHECK (tipo_persona in ('N', 'J')),
	
	nombres varchar(100),
	apaterno varchar(100),
	amaterno varchar(100),

	razon_social varchar (200) not null,
	nombre_comercial varchar(200),

	idtipodocumento int not null,
	numero_documento varchar(20) not null,
	telefono varchar(20)
	constraint CHK_numero_telefono
	CHECK (LEN(Ltrim(RTRIM(telefono))) between 12 and 20
	and telefono not like '%[^0-9+()]%'),
	--+51987654321, (+51)987654321, (01) 654321
	email varchar(150),
	idnacionalidad int not null,
	estado varchar(20) default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_estado
	CHECK (estado in ('Activo', 'Inactivo')),

	constraint PK_persona primary key (idpersona),
	constraint UQ_persona_documento
	UNIQUE (idtipodocumento, numero_documento),

	constraint FK_Persona_tipodocumento
	foreign key (idtipodocumento)
	References RRHH.TipoDocumento (idtipodocumento),
	constraint FK_persona_nacionalidad
	foreign key (idnacionalidad)
	References JLLB.Nacionalidad (idnacionalidad)
);
print 'Tabla Persona Creada';
go

--Crear tabla Persona 
if OBJECT_ID('RRHH.Cargo', 'U') is not null
begin
	Drop Table RRHH.Cargo;
	print 'La tabla RRHH.Cargo Eliminada'; 
end
go

CREATE TABLE RRHH.Cargo (
	idcargo int identity(1,1),
	nomcargo varchar(50) not null,
	descripcion varchar(max),
	salario_base decimal(10,2) not null,
	fecha_registro datetime default getdate(),
	constraint PK_cargo Primary key (idcargo)
);
print 'Tabla Cargo Creada';
go

--Crear tabla Direccion 
if OBJECT_ID('jllb.Direccion', 'U') is not null
begin
	Drop Table jllb.Direccion;
	print 'La tabla jllb.Direccion Eliminada'; 
end
go

CREATE TABLE JLLB.Direccion (
	iddireccion int identity(1,1),
	idciudad int not null,
	tipo_calle nvarchar(50) not null, --Av. Jr. Psje. Prolong. AA.HH.
	calle nvarchar(200) not null, --Atahualpa
	numero nvarchar(10) default 'S/N', --1050, s/n
	referencia nvarchar(max),
	codigo_postal nvarchar(10) not null,
	constraint CHK_zip
	CHECK (len(codigo_postal) between 5 and 10), --06001
	latitud decimal (10,8) null,
	longitud decimal (10,8) null,
	altitud decimal (10,8) null,
	fecha_registro datetime default getdate(),
	constraint PK_direccion primary key (iddireccion),
	constraint FK_direccion_ciudad
	foreign key (idciudad) References jllb.ciudad(idciudad)
);
print 'Tabla Direccion Creada';
go

--Crear tabla Direccion 
if OBJECT_ID('Ventas.Cliente', 'U') is not null
begin
	Drop Table Ventas.Cliente;
	print 'La tabla Ventas.Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Cliente (
	idpersona int not null,
	constraint PK_Cliente primary key (idpersona),
	fecha_nacimiento date not null,
	genero varchar(20), --Masculino, Femenino, Empresa, No Especifica, Prefiero no decirlo
	preferencias_viaje varchar(150) null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, -- Informacion adicional
	puntos_fidelidad int not null default 0,
	nivel_cliente varchar(20) not null default 'Basico', --Basico, Bronze, Plata, Oro
	fecha_registro datetime default getdate(),
	constraint FK_cliente_persona
	Foreign key (idpersona) References RRHH.Persona (idpersona)
);
print 'Tabla Cliente creada';
go

--Crear tabla Empleado 
if OBJECT_ID('RRHH.Empleado', 'U') is not null
begin
	Drop Table RRHH.Empleado;
	print 'La tabla RRHH.Empleado Eliminada'; 
end
go

CREATE TABLE RRHH.Empleado (
	idpersona int not null,
	constraint PK_empleado primary key (idpersona),
	cod_empleado varchar(15) null,
	fecha_ingreso date not null,
	fecha_cese date null,
	tipo_contrato varchar(30) null,
	estado_laboral varchar(20) not null default 'Activo'
	constraint CHK_Estado_laboral
	CHECK (estado_laboral in ('Activo', 'Inactivo', 'Suspendido')),
	jornada_laboral varchar(30) null,
	regimen_laboral varchar(30) null,
	id_supervisor int null,
	contacto_emergencia varchar(150) null,
	telefono_emergencia varchar(20) null,
	observaciones varchar(max) null, -- Informacion adicional
	fecha_registro datetime default getdate(),
	constraint FK_empleado_persona
	Foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_empleado_supervisor
	Foreign key (id_supervisor) References RRHH.Persona (idpersona)
);
print 'Tabla Empleado Creada';
go

--Crear tabla Direccion_cliente 
if OBJECT_ID('Ventas.Direccion_Cliente', 'U') is not null
begin
	Drop Table Ventas.Direccion_Cliente;
	print 'La tabla Ventas.Direccion_Cliente Eliminada'; 
end
go

CREATE TABLE Ventas.Direccion_Cliente ( 
	idpersona int not null,
	iddireccion int not null,
	tipo_direccion varchar(20) not null,
	constraint CHK_tipo_direccion
	CHECK (tipo_direccion in ('Casa', 'Trabajo', 'Facturacion', 'Entrega')),
	es_principal bit not null default 0,
	estado_direccion varchar(20) not null default 'Activo',
	fecha_registro datetime default getdate(),
	constraint CHK_Estado_Direccion_Cliente
	CHECK (estado_direccion in ('Activo', 'Inactivo', 'Suspendido')),
	constraint PK_direccion_cliente
	primary key (idpersona, iddireccion),
	constraint FK_direccion_cliente_persona
	foreign key (idpersona) References RRHH.Persona (idpersona),
	constraint FK_direccion_cliente
	foreign key (iddireccion) References jllb.Direccion (iddireccion)
);
print 'Tabla Direccion Cliente Creada';
go
