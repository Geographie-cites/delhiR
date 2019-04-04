library(ggplot2)
library(cowplot)


n <-  400
x <-  rnorm(n)
y <-  2 *x + rnorm(n)

df <-  data.frame(x=x, y=y)


pp <-  ggplot(df, aes(x=x, y=y))+
  geom_point(colour="firebrick")+
  stat_ellipse(type = "t", level = .68, linetype=1, size=1)+
  stat_ellipse(type = "t", level = .95, linetype=2, size=1)+
  xlab("Longitude X")+
  ylab("Latitude Y")

pp

# Marginal density plot of x (top panel) and y (right panel)


xlabels <- data.frame(
  x = c(xmean -xsd -0.2, xmean-0.2 , xmean-0.2 + xsd),
  y = c(0.25,0.5,0.25),
  text = c("\u03C3", "\u03BC", "\u03C3")
)

xmean <-  mean(x)
xsd <-  sd(x)
xplot <- ggplot(df, aes(x = x))+
  geom_density(fill="#dddddd", colour="#cccccc")+
  geom_vline(xintercept = xmean)+
  geom_vline(xintercept = xmean -xsd, linetype=2)+
  geom_vline(xintercept = xmean +xsd, linetype=2)+
  geom_vline(xintercept = xmean -2*xsd, linetype=3)+
  geom_vline(xintercept = xmean +2*xsd, linetype=3)+
  ylab("Longitude \n distribution ")+
  geom_text(data= xlabels, aes(x=x,y=y,label=text))+
  xlab("")
xplot



ylabels <- data.frame(
  x = c(ymean -ysd -0.2, ymean-0.2 , ymean-0.2 + ysd),
  y = c(0.25,0.5,0.25),
  text = c("\u03C3", "\u03BC", "\u03C3")
)
ymean <-  mean(y)
ysd <-  sd(y)
yplot <- ggplot(df, aes(x = y))+
  geom_density(fill="#dddddd", colour="#cccccc")+
  geom_vline(xintercept = ymean)+
  geom_vline(xintercept = ymean -ysd, linetype=2)+
  geom_vline(xintercept = ymean +ysd, linetype=2)+
  geom_vline(xintercept = ymean -2*ysd, linetype=3)+
  geom_vline(xintercept = ymean +2*ysd, linetype=3)+
  geom_text(data= ylabels, aes(x=x,y=y,label=text))+
  coord_flip()+
  ylab("Latitude \n distribution")+
  xlab("")
yplot


#assemblage
plot_grid(xplot, NULL, pp, yplot, ncol = 2, align = "hv",scale = c(1,1,1,1), 
          rel_widths = c(3, 1), rel_heights = c(1, 3))



