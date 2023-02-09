clc
clear all
close all

load channeling_events

% Loading data from the dynamic table into regular vectors
gotchis = channeling_events.Gotchi_id;
parcels = channeling_events.Realm_id;
FUD = channelingevents.FUD;
spillover = channelingevents.spilloverRate/10000;

% Getting day of each channeling event
blockDateTime = char(channelingevents.evt_block_time);
blockDate = string(blockDateTime(:,1:10));

% Calculating kinship based on the amount of FUD produced per channeling
kinship = 50*(FUD/(20)).^2;

