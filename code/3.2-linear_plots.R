# Load libraries and functions
source('./code/1.1-loadTools.R')

# Load and run linear model:
source('./code/3.1-linear_model.R')

# -----------------------------------------------------------------------------
# Plot results

# Get the model coefficients:
coefs = coef(model_linear)
coefs

# Create data frames for plotting each attribute:
#   level   = The attribute level (x-axis)
#   utility = The utility associated with each level (y-axis)
df_price = data %>%
    distinct(level = price) %>%
    arrange(level) %>%
    mutate(utility = (level - min(level)) * coefs['price'])
df_fuelEconomy = data %>%
    distinct(level = fuelEconomy) %>%
    arrange(level) %>%
    mutate(utility = (level - min(level)) * coefs['fuelEconomy'])
df_accelTime = data %>%
    distinct(level = accelTime) %>%
    arrange(level) %>%
    mutate(utility = (level - min(level)) * coefs['accelTime'])
df_powertrain = data %>%
    distinct(level = powertrain) %>%
    mutate(utility = c(coefs['powertrain_elec'], 0))

# Get y-axis upper and lower bounds (plots should have the same y-axis):
utility = c(df_price$utility, df_fuelEconomy$utility, df_accelTime$utility, 
            df_powertrain$utility) 
ymin = min(utility)
ymax = max(utility)

# Plot the utility for each attribute
plot_price = ggplot(df_price,
    aes(x=level, y=utility)) +
    geom_line() +
    scale_y_continuous(limits=c(ymin, ymax)) +
    labs(x='Price ($1000)', y='Utility') +
    theme_bw()
plot_fuelEconomy = ggplot(df_fuelEconomy,
    aes(x=level, y=utility)) +
    geom_line() +
    scale_y_continuous(limits=c(ymin, ymax)) +
    labs(x='Fuel Economy (mpg)', y='Utility') +
    theme_bw()
plot_accelTime = ggplot(df_accelTime,
    aes(x=level, y=utility)) +
    geom_line() +
    scale_y_continuous(limits=c(ymin, ymax)) +
    labs(x='0-60mph Accel. Time (sec)', y='Utility') +
    theme_bw()
plot_powertrain = ggplot(df_powertrain,
    aes(x=level, y=utility)) +
    geom_point() +
    scale_y_continuous(limits=c(ymin, ymax)) +
    labs(x='Powertrain Electric', y='Utility') +
    theme_bw()

# Plot all plots in one figure
multiplot = grid.arrange(plot_price, plot_fuelEconomy, plot_accelTime, plot_powertrain, nrow=1)

# Save plots 
mainwd = getwd()
setwd('./results/plots/coefficients')
ggsave('./linear_price.pdf', plot_price, width=4, height=3)
ggsave('./linear_fuelEconomy.pdf', plot_fuelEconomy, width=4, height=3)
ggsave('./linear_accelTime.pdf', plot_accelTime, width=4, height=3)
ggsave('./linear_powertrain.pdf', plot_powertrain, width=4, height=3)
ggsave('./linear_multiplot.pdf', multiplot, width=10, height=2.5)
setwd(mainwd)

