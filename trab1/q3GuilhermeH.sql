--Universidade da Fronteira Sul
--Aluno: Guilherme Hermes

drop table pagerevision;

drop table pageaudit;

drop function audit_revisao;

create table pagerevision(id serial primary key, title varchar(50) not null, data date, author varchar(50) not null, text text not null);

create table pageaudit(id serial primary key, pageid int, oldtitle varchar(50), newtitle varchar(50), data date, dif_len int, oldauthor varchar(50), newauthor varchar(50), oldtext text, newtext text);

create or replace function audit_revisao()
returns trigger as $$
declare
	len integer;
begin
	if new.title is null then
		raise exception 'Titulo nao ser vazio';
	end if;

	len = length(old.text) - length(new.text);

	if len < 0 then
		len = len * (-1);
	end if;

insert into pageaudit(pageid, dif_len, oldtitle, newtitle, data, newauthor,  oldauthor, newtext, oldtext) values(old.id, len, old.title, new.title, current_timestamp, new.author,old.author,  new.text, old.text);
	return new;
end;
$$ language plpgsql;

create trigger audit_revisao
	before update on pagerevision
	for each row
	execute procedure audit_revisao();


insert into pagerevision(title, data,  author, text) values ('It',current_timestamp, 'Stephen King', 'Mt loco tudo isso'),('Beento',current_timestamp, 'Humberto', 'descr aqui'),('Inverno',current_timestamp, 'Bernarno', 'hue');

select * from pagerevision;

select * from pageaudit;

update 	pagerevision set (title, author, text) = ('GLOW', 'Trex', 'lol') where id = '1';

select * from pagerevision;

select * from pageaudit;

update 	pagerevision set (title, author, text) = ('Mindhunter', 'Jim', 'Netflix') where id = '1';

select * from pagerevision;

select * from pageaudit;



