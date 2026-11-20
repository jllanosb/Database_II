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
	constraint PK_region primary key (idregion),
	constraint UQ_nomregion UNIQUE (nomregion),
	constraint FK_region_pais
	foreign key (idpais) References JLLB.Pais (idpais)
);
print 'Tabla Region Creada';
go

