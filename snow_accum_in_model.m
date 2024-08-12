clear
%date of each experiment
dates = datenum('02-Jan-2018'):datenum('03-Jan-2019');
datestring = datestr(dates, 'yyyymmdd');
datevect=datevec(dates);

datestring=[datestring(1:274,:);datestring(279:365,:)];
datevect=[datevect(1:274,:);datevect(279:365,:)];

x0=(1:length(datevect))';
[x1,]=find(datevect(:,2)==3 | datevect(:,2)==1 | datevect(:,2)==2);
[x2,]=find(datevect(:,2)==6 | datevect(:,2)==4 | datevect(:,2)==5);
[x3,]=find(datevect(:,2)==9 | datevect(:,2)==7 | datevect(:,2)==8);
[x4,]=find(datevect(:,2)==12 | datevect(:,2)==10 | datevect(:,2)==11);
X={x0,x1,x2,x3,x4};

cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools
load('lon25.mat')
load('lat25.mat')

data=ncread('/Volumes/ExtremePro/Extreme_SSD/SIT_2018_daily/SIT/Temp_15_polargrid.nc','SNOWH');
SNOWH_SIT_15=permute(data,[2 1 3]);

for i=1:length(x0)
   seaice=ncread(['/Volumes/ExtremePro/WANG_SSD/NOAA_NSIDC_CDR_SICv4_G02202/seaice_conc_daily_sh_',datestring(i,:),'_f17_v04r00.nc'],'cdr_seaice_conc');
   seaice_cdr=seaice';
   seaice_cdr(seaice_cdr>1)=0;
   SNOWH_SIT_15_r=SNOWH_SIT_15(:,:,(i-1)*24+1:i*24); % add one hour here for keep consistans with MODIS
   for j=1:24
    SNOWH_SIT_15_r1=SNOWH_SIT_15_r(:,:,j);
    SNOWH_SIT_15_r1(seaice_cdr<0.8)=nan;
    SNOWH_SIT_15_r1(isnan(seaice_cdr))=nan;
    SNOWH_SIT_15_r(:,:,j)=SNOWH_SIT_15_r1;
   end
   data_SNOWH_SIT_15_r(:,:,i)=mean((SNOWH_SIT_15_r),3,'omitnan'); 
end



x0=(1:length(datevect))';
for i=1:12
Month{i}=find(datevect(:,2)==i);
end

for j=1:12
data_SNOWH_SIT_15_Month{j}=mean(data_SNOWH_SIT_15_r(:,:,Month{j}),3,'omitnan');
end

% exclude outliers
% Upon examination, the likelihood of accumulating over 1 meter of snowfall
% within 48 hours due to precipitation is extremely low. 
% The instances of more than 1 meter are due to erroneous interpolation of 
% ice sheet and ice shelves(sometimes exceeding 50 meters). Therefore, these should be excluded.
for j=1:12
data_SNOWH_SIT_15_Month{j}(data_SNOWH_SIT_15_Month{j}>1)=nan;
end

% I have set the snow depth in the source code to not be less than 5 cm. 
% Thus, any instances where snow depth is less than 5 cm are either due to the presence of the ocean 
% or interpolation errors, and should also be excluded.
for j=1:12
data_SNOWH_SIT_15_Month{j}(data_SNOWH_SIT_15_Month{j}<0.05)=nan;
end

% domain-average for all experiments
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';

%monthly domain mean
for i=1:12
SNOWH_SIT_15_monthly_sum(i)=nansum(data_SNOWH_SIT_15_Month{i}.*area_nasa,'all')./nansum(area_nasa(~isnan(data_SNOWH_SIT_15_Month{i})),'all');
end



figure
plot(SNOWH_SIT_15_monthly_sum.*100,'LineWidth',2)
xlim([1 12])
xlabel('month')
ylabel('SNOWH (cm)')
set(gca,'FontSize',22);
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 11 12],'xticklabels',({'Jan', 'Feb', 'Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}) );
