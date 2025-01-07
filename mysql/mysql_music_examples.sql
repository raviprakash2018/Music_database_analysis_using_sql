-- 1.List all artists for each record label sorted by artist name. 
SELECT 
    artist.name, record_label.name
FROM
    record_label
        JOIN
    artist ON record_label.id = artist.record_label_id
ORDER BY artist.name ASC;


-- 2. Which record labels have no artists?
SELECT 
    record_label.name
FROM
    record_label
        LEFT JOIN
    artist ON record_label.id = artist.record_label_id
WHERE
    artist.record_label_id IS NULL;


-- 3. List the number of songs per artist in descending order
select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name order by count(*) desc;
   
   
-- 4. Which artist or artists have recorded the most number of songs?
select artist.name,count(*) as Number_of_Songs   
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name order by count(*) desc limit 1;


-- 5. Which artist or artists have recorded the least number of songs?
select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name having count(*)=(select min(Number_of_Songs) from (select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name) temp);


-- 6. How many artists have recorded the least number of songs?
-- Hint: we can wrap the results of query 4. with another select to give us total artist count.
select  count(Number_of_Songs) as Number_of_artists_having_recorded_the_Least_number_of_Songs from (select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name having count(*)=(select min(Number_of_Songs) from (select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name) temp1))temp2;
 


-- 7. which artists have recorded songs longer than 5 minutes, and how many songs was that?
select name as Artist_Name,count(*) as No_of_Songs_longer_than_5_minutes from(select artist.name,song.duration 
from album join song on album.artist_id=song.album_id
join artist on artist.id=album.artist_id
where duration >5) temp
group by Artist_Name;


-- 8. for each artist and album how many songs were less than 5 minutes long?
select artist.name,album.name,count(*) as Number_of_songs_less_than_5_minutes
 from song
join album on song.album_id=album.id
join artist on album.artist_id=artist.id 
where duration<5
group by artist.name,album.name;


-- 9. in which year or years were the most songs recorded?

select album.year,count(*) as Number_of_Songs_recorded
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by album.year having count(*)=(select max(Number_of_Songs) from (select artist.name,count(*) as Number_of_Songs
from song join album on song.album_id=album.id
 join artist on album.artist_id=artist.id
 group by artist.name) temp1);


 -- 10. list the artist, song and year of the top 5 longest recorded songs
select artist.name,song.name,album.year,song.duration from 
artist join album on artist.id=album.artist_id
join song on song.album_id=album.id
order by song.duration desc
limit 5;


-- 11. Number of albums recorded for each year
select year,count(*) as Number_of_Albums_recorded from album
group by year;


-- 12. What is the max number of recorded albums across all the years?
-- Hint:  using the above sql as a temp table
select max(Number_of_Albums_recorded) as Maximum_number_of_albums_recorded_across_all_years from (select year,count(*) as Number_of_Albums_recorded from album
group by year) temp;

-- 13. In which year (or years) were the most (max) number of albums recorded, and how many were recorded?
-- Hint: using the above sql as a sub-select
select year, count(*) as Maximum_number_of_albums_recorded from album
group by year
having count(*)= (select max(Number_of_Albums_recorded) from (select year,count(*) as Number_of_Albums_recorded from album
group by year) as  temp);


-- 14. total duration of all songs recorded by each artist in descending order
select artist.name,sum(song.duration) as Total_Duration_of_All_Songs
from song join album on song.album_id=album.id
join artist on artist.id=album.artist_id
group by artist.name
order by Total_Duration_of_All_Songs desc;


-- 15. for which artist and album are there no songs less than 5 minutes long?
select artist.name,album.name
from artist left join album on artist.id=album.artist_id
left join song on song.album_id=album.id and song.duration<5
where song.name is null;


-- 16. Display a table of all artists, albums, songs and song duration 
--     all ordered in ascending order by artist, album and song  
select artist.name,album.name,song.name,song.duration
from artist  join album on artist.id=album.artist_id
join song on song.album_id=album.id
order by artist.name asc,album.name asc,song.name asc;


-- 17. List the top 3 artists with the longest average song duration, in descending with longest average first.
  select artist.name,avg(song.duration) as Average_song_duration from 
   artist  join album on artist.id=album.artist_id
 join song on song.album_id=album.id 
group by artist.name
order by Average_song_duration desc
limit 3;


-- 18. Total album length for all songs on the Beatles Sgt. Pepper's album - in minutes and seconds.
select album.name, floor(sum(song.duration)) as minutes,round(mod(sum(song.duration),1)*60) as seconds
from album join song on song.album_id=album.id
where album.name like 'Sgt%'
group by album.name; 

   
-- 19. Which artists did not release an album during the decades of the 1980's and the 1990's?
select distinct artist.name from artist left join album on artist.id=album.artist_id and album.year>=1980 and album.year<=1990
where year is  null
order by artist.name;


-- 20. Which artists did release an album during the decades of the 1980's and the 1990's? 
select distinct artist.name from artist left join album on artist.id=album.artist_id and album.year>=1980 and album.year<=1990
where year is  not null
order by artist.name;
