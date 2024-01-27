clear
%date of each experiment
dates = [datenum('01-Dec-2002'):datenum('30-Nov-2020')];
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);
% plot a spatial pattern of climtology mean error of reanalyses in four season (DJF MAM JJA SON)
% so this is a pattern plot 6 (reanalysis+sate) x 4 (seasons)
x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};

cd /Users/zhaohuiw/Desktop

load('data_ME.mat')


load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/area_nasa.mat')
area_nasa=area_nasa';
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lon25.mat')
load('/Volumes/ExtremePro/WANG_SSD/programming_files_stage2/modis/nsidc_grid_tools/lat25.mat')

%% Plots of the average (2002-2020) domain averaged temperture for each day (k).
for day = 1:365
 x=find(datevec(:,2)==datevec(day+31,2) & datevec(:,3)==datevec(day+31,3)); % +31 to move Jan to the first xtick
 
 IST_ERA5_dailyME(:,:,day)=nanmean(data_ME_ERA5(:,:,x),3); 
 IST_ERAI_dailyME(:,:,day)=nanmean(data_ME_ERAI(:,:,x(x<=6118)),3); 
 IST_MERRA2_dailyME(:,:,day)=nanmean(data_ME_MERRA2(:,:,x),3); 
 IST_JRA55_dailyME(:,:,day)=nanmean(data_ME_JRA55(:,:,x),3); 
 IST_NCEPR2_dailyME(:,:,day)=nanmean(data_ME_NCEPR2(:,:,x),3); 
end
for i=1:365
IST_ERA5_daily_sum_hourly(i)=nansum(IST_ERA5_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_ERA5_dailyME(:,:,i))),'all');
IST_MERRA2_daily_sum_hourly(i)=nansum(IST_MERRA2_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_MERRA2_dailyME(:,:,i))),'all');
IST_ERAI_daily_sum_6hourly(i)=nansum(IST_ERAI_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_ERAI_dailyME(:,:,i))),'all');
IST_NCEPR2_daily_sum_6hourly(i)=nansum(IST_NCEPR2_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_NCEPR2_dailyME(:,:,i))),'all');
IST_JRA55_daily_sum_3hourly(i)=nansum(IST_JRA55_dailyME(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_JRA55_dailyME(:,:,i))),'all');
end

%% Plots of the average (2002-2020) RMSE between reanalyses and MODIS for each day (k)

%rmse
for day = 1:365
 x=find(datevec(:,2)==datevec(day+31,2) & datevec(:,3)==datevec(day+31,3));
 IST_ERA5_dailyrmse(:,:,day)=sqrt(mean(data_ME_ERA5(:,:,x),3,'omitnan').^2); 
 IST_MERRA2_dailyrmse(:,:,day)=sqrt(mean(data_ME_MERRA2(:,:,x),3,'omitnan').^2); 
 IST_ERAI_dailyrmse(:,:,day)=sqrt(mean(data_ME_ERAI(:,:,x(x<=6118)),3,'omitnan').^2); 
 IST_NCEPR2_dailyrmse(:,:,day)=sqrt(mean(data_ME_NCEPR2(:,:,x),3,'omitnan').^2); 
 IST_JRA55_dailyrmse(:,:,day)=sqrt(mean(data_ME_JRA55(:,:,x),3,'omitnan').^2); 
end

for i=1:365
IST_rmse_ERA5_daily_sum_hourly(i)=nansum(IST_ERA5_dailyrmse(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_ERA5_dailyrmse(:,:,i))),'all');
IST_rmse_MERRA2_daily_sum_hourly(i)=nansum(IST_MERRA2_dailyrmse(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_MERRA2_dailyrmse(:,:,i))),'all');
IST_rmse_ERAI_daily_sum_6hourly(i)=nansum(IST_ERAI_dailyrmse(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_ERAI_dailyrmse(:,:,i))),'all');
IST_rmse_NCEPR2_daily_sum_6hourly(i)=nansum(IST_NCEPR2_dailyrmse(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_NCEPR2_dailyrmse(:,:,i))),'all');
IST_rmse_JRA55_daily_sum_3hourly(i)=nansum(IST_JRA55_dailyrmse(:,:,i).*area_nasa,'all')./nansum(area_nasa(~isnan(IST_JRA55_dailyrmse(:,:,i))),'all');
end



figure
subplot(2,1,1)
hold on
plot(1:365,IST_ERA5_daily_sum_hourly,'LineWidth',2)
plot(1:365,IST_MERRA2_daily_sum_hourly,'LineWidth',2)
plot(1:365,IST_ERAI_daily_sum_6hourly,'LineWidth',2)
plot(1:365,IST_NCEPR2_daily_sum_6hourly,'LineWidth',2)
plot(1:365,IST_JRA55_daily_sum_3hourly,'LineWidth',2)
plot(1:365,0*(1:365),'--','LineWidth',2)
hold off
legend('ERA5','MERRA2','ERA-Interim','NCEPR2','JRA55');
xticks([31,62,90,121,151,182,212,243,274,304,335,365])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
xlim([1 365])
set(gca,'FontSize',22);
ylabel('Mean Bias (K)')
%title('Plots of the average (2002-2020) bias between reanalyses and MODIS for each day (k)','FontSize',24)
text(2,11.2,'(a)','FontSize',22)

subplot(2,1,2)
hold on
plot(1:365,IST_rmse_ERA5_daily_sum_hourly,'LineWidth',2)
plot(1:365,IST_rmse_MERRA2_daily_sum_hourly,'LineWidth',2)
plot(1:365,IST_rmse_ERAI_daily_sum_6hourly,'LineWidth',2)
plot(1:365,IST_rmse_NCEPR2_daily_sum_6hourly,'LineWidth',2)
plot(1:365,IST_rmse_JRA55_daily_sum_3hourly,'LineWidth',2)
%plot(1:365,0*(1:365),'--','LineWidth',2)
hold off
legend('ERA5','MERRA2','ERA-Interim','NCEPR2','JRA55');
xticks([31,62,90,121,151,182,212,243,274,304,335,365])
xticklabels({'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'})
xlim([1 365])
set(gca,'FontSize',22);
ylabel('RMSE (K)')
text(2,11,'(b)','FontSize',22)
