clear
%date of each experiment
dates = datenum('01-Dec-2002'):datenum('30-Nov-2020');
datestr = datestr(dates, 'yyyymmdd');
datevec=datevec(dates);

x0=(1:length(datevec))';
[x1,]=find(datevec(:,2)==3 | datevec(:,2)==1 | datevec(:,2)==2);
[x2,]=find(datevec(:,2)==6 | datevec(:,2)==4 | datevec(:,2)==5);
[x3,]=find(datevec(:,2)==9 | datevec(:,2)==7 | datevec(:,2)==8);
[x4,]=find(datevec(:,2)==12 | datevec(:,2)==10 | datevec(:,2)==11);
X={x0,x1,x2,x3,x4};


cd /Users/zhaohuiw/Desktop/Work/programming_files_stage2/modis/nsidc_grid_tools

load('lon25.mat')
load('lat25.mat')

%change to gauss resampling method, code below are not used:
%cd /Users/zhaohuiw/Desktop/Onedrive_backup/PHD_Thesis/figures_code/paper2
%load Figure16_paper2_corr_CERES_TCF *_ME_masked

% now changed to gauss resampling method
cd /Users/zhaohuiw/Documents/GitHub/Warm-Bias-in-Atmospheric-Reanalyses-over-Antarctic-Sea-Ice
load cloud_fra_clear_sky *_ME_masked

text_no1={'(a)','(b)','(c)','(d)','(e)'};
text_no2={'(f)','(g)','(h)','(i)','(j)'};

text_all={text_no1};

ERA5_ME_masked_Gauss=ERA5_ME_masked;
ERAI_ME_masked_Gauss=ERAI_ME_masked;
JRA55_ME_masked_Gauss=JRA55_ME_masked;
MERRA2_ME_masked_Gauss=MERRA2_ME_masked;
NCEPR2_ME_masked_Gauss=NCEPR2_ME_masked;


%change to gauss resampling method, code below are not used:
cd /Users/zhaohuiw/Desktop/Onedrive_backup/PHD_Thesis/figures_code/paper2
load Figure16_paper2_corr_CERES_TCF *_ME_masked



figure
set(gcf,'unit','normalized','position',[0.0 0.0 1.0 .60]) % [left bottom width height]
data_name={'ERA5', 'ERAI', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
data_name_title={'ERA5', 'ERA-Interim', 'MERRA2', 'NCEPR2', 'JRA55','FNL'};
season={'ALL','JFM','AMJ','JAS','OND'};

% plot IST biases without TCF mask
q=1;
for i=1:5
    for j=1
ax1=axes('position',[0.15*(i-1) 0.50 .37 .37]); % [left bottom width height]
m_contourf(lons,lats,eval([data_name{i},'_ME_masked_Gauss{1}']), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(colortable(1:5:end,:));
q=q+1;
        
title(data_name{i},'FontSize',16,'Interpreter','none')      
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end

if i==1
ylabel('Gauss','FontSize',22,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no1{i},'fontsize',28,'fontname','bold')
end


for i=1:5
    for j=1
ax2=axes('position',[0.15*(i-1) 0.10 .37 .37]); % [left bottom width height]
m_contourf(lons,lats,eval([data_name{i},'_ME_masked{1}']), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(colortable(1:5:end,:));
q=q+1;
        
%         if j==1
%          ylabel(data_name{1},'FontSize',16,'fontweight','bold')
%         end

if i==1
ylabel('Nearest neighbour','FontSize',22,'FontWeight','bold')
end

    end
m_text(-45,-45,text_no2{i},'fontsize',28,'fontname','bold')
end



h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','SNOWH (cm)')
h.Label.String = 'Cloud fraction';
set(h,'position',[.88 .25 .01 .5])