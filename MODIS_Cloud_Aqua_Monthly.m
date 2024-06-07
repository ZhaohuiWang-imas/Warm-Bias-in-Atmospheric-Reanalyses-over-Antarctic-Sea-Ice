
% 指定文件夹路径
folder_path = '/Volumes/ExtremePro/Extreme_SSD/MODIS_cloud/CLDPROP_M3_MODIS_Aqua/'; % 

% 获取所有NetCDF文件的列表
file_pattern = fullfile(folder_path, '*.nc');
nc_files = dir(file_pattern);

% 将文件名排序
[~, idx] = sort({nc_files.name});
nc_files = nc_files(idx);

for k = 1:length(nc_files)
    % 获取文件的完整路径
    file_path = fullfile(nc_files(k).folder, nc_files(k).name);
    
    % 读取NetCDF文件中的数据
    data = ncread(file_path, 'Cloud_Fraction/Mean'); % 替换为实际变量名称
    

    cloud_monthly(:,:,k)=data;
end

longitude=ncread(file_path, 'longitude');
latitude=ncread(file_path, 'latitude');


%画图

text_all={'(a)','(b)','(c)','(d)','(e)','(f)','(g)','(h)'};
data_name={'CERES','ERA5','ERAI','MERRA2','JRA55','NCEPR2'};
title_name={'CERES','ERA5','ERA-Interim','MERRA2','JRA55','NCEPR2'};
figure
[ha, pos] = tight_subplot(2,3,[.01 .015],[.01 .04],[.03 .1]);
for j=1:6
axes(ha(j));
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_contourf(lons,lats,eval([data_name{j},'_ME_season']), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(colortable(1:5:end,:));
title(title_name{j},'FontSize',18)
m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
end
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Cloud Fraction';
set(h,'position',[.925 .25 .01 .5])


%test

figure
m_proj('azimuthal equal-area','latitude',-87,'longitude',3,'radius',47.9,'rectbox','on');
m_contourf(longitude,latitude,mean(cloud_monthly,3,'omitnan'), 0:0.05:1,'LineStyle','None');
m_grid('tickdir','in','xtick',-180:60:180,'ytick',-80:10:-60,'fontsize',16,'tickdir','in','xticklabel','','yticklabel','','box','fancy');
m_gshhs_l('color','k');
caxis([0 1])
colortable =textread('WhBlGrYeRe.txt');
colormap(colortable(1:5:end,:));
%title(title_name{j},'FontSize',18)
%m_text(-43,-45,text_all{j},'fontsize',22,'fontname','bold')
h=colorbar('eastoutside');
set(h,'fontsize',18,'tickdir','out','linewidth',1)
%set(get(h,'Title'),'string','Cloud fraction')
h.Label.String = 'Cloud Fraction';
set(h,'position',[.925 .25 .01 .5])
