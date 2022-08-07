install.packages('tinytex')
tinytex::install_tinytex()
update.packages(ask = FALSE, checkBuilt = TRUE)
tinytex::tlmgr_update()
tinytex::reinstall_tinytex()

# aggregated average hourly intensities? finding, on average, each participant's intensity was
hours %>%
  group_by(time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  ggplot(aes(x=time, y=hourly_avg_intensity, fill=hourly_avg_intensity)) + 
  geom_col() +
  labs(title = "Hourly average intensities", x="Hour", y="Average Intensity") + 
  scale_fill_gradient(low = "blue", high = "red")

daily_activity %>%
  group_by(id) %>%
  summarise(sedentary_distance=mean(sedentary_active_distance),
            lightly_distance=mean(light_active_distance),
            moderately_distance=mean(moderately_active_distance),,
            very_distance=mean(very_active_distance),
            total_distance=mean(total_distance)) %>%
  pivot_longer(names_to = "mean_distance", 
               values_to = "distance", 
               c(sedentary_distance,lightly_distance,moderately_distance,very_distance)) %>%
  mutate(mean_distance=factor(mean_distance, 
                              levels = c("sedentary_distance", "lightly_distance", "moderately_distance","very_distance"),
                              ordered = TRUE)) %>%
  ungroup() %>%
  arrange(desc(total_distance)) %>%
  mutate(id = factor(id, levels = unique(id))) %>%
  ggplot() +
  geom_col(mapping = aes(x=id,y=distance,fill=mean_distance)) +
  coord_flip() + 
  labs(title = "Participants by active distance") + 
  scale_fill_discrete(type = c(very_distance = "#238b45",
                               moderately_distance="#66c2a4",
                               lightly_distance="#b2e2e2",
                               sedentary_distance="#edf8fb"), 
                      aesthetics = "fill", 
                      breaks = c("very_distance", "moderately_distance", "lightly_distance", "sedentary_distance")) +
  guides(fill=guide_legend(reverse = T)) +
  theme(axis.text.y=element_blank(), axis.ticks.y = element_line(colour = "grey"), 
        legend.title = element_blank(), 
        legend.position = c(.75,.6), 
        legend.background = element_blank())

hours %>%
  group_by(id, time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  ggplot(aes(x = time, y = hourly_avg_intensity, group = time)) +
  geom_point(alpha = 0.3, position = "jitter", color = "tomato") +
  geom_boxplot(alpha = 0, colour = "black") +
  coord_flip()
ggplot(hours, aes(x = time, y = average_intensity, group = time)) +
  geom_point(alpha = 0.3, position = "jitter", color = "tomato") +
  geom_boxplot(alpha = 0, colour = "black") +
  coord_flip()
hours %>%
  filter(time <= 12) %>%
  ggplot(aes(x = time, y = average_intensity, group = time)) +
  geom_point(alpha = 0.3, position = "jitter", color = "tomato") +
  geom_boxplot(alpha = 0, colour = "black") +
  coord_flip()
hours %>%
  filter(time >= 12) %>%
  ggplot(aes(x = time, y = average_intensity, group = time)) +
  geom_point(alpha = 0.3, position = "jitter", color = "tomato") +
  geom_boxplot(alpha = 0, colour = "black") +
  coord_flip()


# Now for calories
hours %>%
  group_by(time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  ggplot(aes(x=time, y=hourly_avg_intensity, fill=hourly_avg_intensity)) + 
  geom_col() +
  labs(title = "Hourly average intensities", x="Hour", y="Average Intensity") + 
  scale_fill_gradient(low = "blue", high = "red")


glimpse(hours)

ggplot(hours, aes(x=time, y=calories), color = "red") + geom_col()
ggplot(hours, aes(x=time, y=total_intensity)) + geom_col()
ggplot(hours, aes(x=time, y=average_intensity)) + geom_col()
ggplot(hours, aes(x=time, y=step_total)) + geom_col()









#### ok... what about maxes?? is it useful to see what time of day people are most intense?

# just the maxes
hours %>%
  group_by(id, time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  group_by(id) %>%
  mutate(min_intensity = min(hourly_avg_intensity),
         max_intensity = max(hourly_avg_intensity)) %>%
  filter(hourly_avg_intensity == max_intensity) %>%
  arrange(hourly_avg_intensity) %>%
  ggplot(aes(x=time, y=max_intensity, fill=max_intensity)) + 
  geom_col() + 
  labs(title = "Hourly max intensities", x="Time (hr)", y="Max intensities") + 
  scale_fill_gradient(low = "blue", high = "red")                                     
### OK now i feel justified separating the id's lol


# just counting the number of maxes at certain time point
hours %>%
  group_by(id, time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  group_by(id) %>%
  mutate(min_intensity = min(hourly_avg_intensity),
         max_intensity = max(hourly_avg_intensity)) %>%
  filter(hourly_avg_intensity == max_intensity) %>%
  group_by(id, time) %>%
  summarize(n = n()) %>%
  arrange(time) %>%
  ggplot(aes(x=time, y=n, fill=n)) + 
  geom_col()


## Now min intensities (although might have multiple mins?)
hours %>%
  group_by(id, time) %>%
  summarise(hourly_avg_intensity = mean(average_intensity))  %>%
  group_by(id) %>%
  mutate(min_intensity = min(hourly_avg_intensity),
         max_intensity = max(hourly_avg_intensity)) %>%
  filter(hourly_avg_intensity == min_intensity) %>%
  arrange(time) %>%
  ggplot(aes(x=time, y=min_intensity, fill=min_intensity)) + 
  geom_col() + 
  labs(title = "Hourly min intensities", x="Time (hr)", y="Min intensities") + 
  scale_fill_gradient(low = "blue", high = "red")    

# and this makes sense because you should have lowest intensities for sleeping hrs




















install.packages("GGally")
install.packages("Hmisc")
library("GGally")
library(Hmisc)
library(tidyverse)
hours %>%
  select(calories,average_intensity,step_total) %>%
  ggcorr(nbreaks = 23,label = T,label_round = 2,limits = c(0,1))
hours %>%
  select(calories,average_intensity,step_total) %>%
  cor()
hours.rcorr <- hours %>%
  select(calories,average_intensity,step_total) %>%
  as.matrix() %>%
  rcorr()
hours.rcorr$P < .01


colnames(daily_activity_sleep)
glimpse(daily_activity_sleep)
daily_activity_sleep %>%
  select(-id, -tracker_distance, -logged_activities_distance, -activity_date, -time, -total_sleep_records,-sleep_day) %>%
  rename(sleep_min = total_minutes_asleep) %>%
  ggcorr(nbreaks = 8)
         
         (,limits = c(0,1))

hours %>%
  select(calories,average_intensity,step_total) %>%
  as.matrix() %>%
  cor()
rcorr()










##minutes for activity, graphed
daily_activity %>%
  group_by(id) %>%
  summarise(sedentary_distance=mean(sedentary_active_distance),sedentary_minutes=mean(sedentary_minutes),
            lightly_distance=mean(light_active_distance),lightly_minutes=mean(lightly_active_minutes),
            moderately_distance=mean(moderately_active_distance),moderate_minutes=mean(fairly_active_minutes),
            very_distance=mean(very_active_distance),very_minutes=mean(very_active_minutes),
            total_minutes=mean(sum(sedentary_minutes,lightly_minutes,moderate_minutes,very_minutes))) %>%
  pivot_longer(names_to = "mean_minutes", 
               values_to = "minutes", 
               c(sedentary_minutes,lightly_minutes,moderate_minutes,very_minutes)) %>%
  mutate(mean_minutes=factor(mean_minutes, 
                             levels = c("sedentary_minutes", "lightly_minutes", "moderate_minutes","very_minutes"),
                             ordered = TRUE)) %>%
  ungroup() %>%
  arrange(total_minutes) %>%
  mutate(id = factor(id, levels = unique(id))) %>%
  ggplot() +
  geom_col(mapping = aes(x=id,y=minutes,fill=mean_minutes)) +
  theme(axis.text.x = element_text(angle = 90))


daily_activity %>%
  group_by(id) %>%
  mutate(prop_sedentary = sedentary_minutes / sum(sedentary_minutes,lightly_active_minutes,
                                                  fairly_active_minutes,very_active_minutes),
         prop_light = lightly_active_minutes / sum(sedentary_minutes,lightly_active_minutes,
                                                   fairly_active_minutes,very_active_minutes),
         prop_moderately = fairly_active_minutes / sum(sedentary_minutes,lightly_active_minutes,
                                                       fairly_active_minutes,very_active_minutes),
         prop_very = very_active_minutes / sum(sedentary_minutes,lightly_active_minutes,
                                               fairly_active_minutes,very_active_minutes),
         total_minutes=mean(sum(sedentary_minutes,lightly_active_minutes,fairly_active_minutes,very_active_minutes))) %>%
  pivot_longer(names_to = "prop_minutes", values_to = "proportion", prop_sedentary:prop_very) %>%
  mutate(prop_minutes=factor(prop_minutes, 
                             levels = c("prop_sedentary", "prop_light", "prop_moderately","prop_very"),
                             ordered = TRUE)) %>%
  ungroup() %>%
  arrange(desc(total_minutes)) %>%
  mutate(id = factor(id, levels=unique(id))) %>%
  ggplot() +
  geom_col(mapping = aes(x=id,y=proportion,fill=prop_minutes)) +
  coord_flip()


##The vast majority of minutes are spent being sedentary.








daily_activity %>%
  group_by(id) %>%
  summarise(sedentary_distance=mean(sedentary_active_distance),sedentary_minutes=mean(sedentary_minutes),
            lightly_distance=mean(light_active_distance),lightly_minutes=mean(lightly_active_minutes),
            moderately_distance=mean(moderately_active_distance),moderate_minutes=mean(fairly_active_minutes),
            very_distance=mean(very_active_distance),very_minutes=mean(very_active_minutes),
            total_distance=mean(total_distance)) %>%
  pivot_longer(names_to = "mean_distance", 
               values_to = "distance", 
               c(sedentary_distance,lightly_distance,moderately_distance,very_distance)) %>%
  mutate(mean_distance=factor(mean_distance, 
                              levels = c("sedentary_distance", "lightly_distance", "moderately_distance","very_distance"),
                              ordered = TRUE)) %>%
  ungroup() %>%
  arrange(total_distance) %>%
  mutate(id = factor(id, levels = unique(id))) %>%
  ggplot() +
  geom_col(mapping = aes(x=id,y=distance,fill=mean_distance)) +
  theme(axis.text.x = element_text(angle = 90))
