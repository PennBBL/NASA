##################################################
# data simulation for NASA Antartica paper
# to check what happens if we do or do not
# omit cognition from the model
##################################################
# load lme4 package
library(lme4)

# model:
# y = intercept + scanner2 + scanner3 + time12 (+ cognition) + subject + error

# simulate the coefficients
intercept <- 10
scanner2 <- 1
scanner3 <- -1
time12 <- -2
cognition <- 1
coefs <- c(intercept,
           scanner2,
           scanner3,
           time12,
           cognition)

# create the design matrix X
# 4 phantoms (ids=1:4) scanned on all 3 scanners at time0
# 22 crew members (ids=5:26) scanned on scanner1 at time 0
# 22 crew members (ids=5:26) scanned on scanners 2 & 3 at time12
# (19 crew members scanned on scanner 1 at time t18 -- omitting this time point)
## columns of design matrix
x_ids <- c(rep(1:4, 3),
           rep(5:26, 2))
x_scanner <- factor(c(rep('scanner1', 4),
              rep('scanner2', 4),
              rep('scanner3', 4),
              rep('scanner1', 22),
              rep('scanner2', 11),
              rep('scanner3', 11)))
x_time <- factor(c(rep('time0', 34),
            rep('time12', 22)))
# cognition at time0 will be ~ N(mean=130, sd=5)
# cognition at time12 will be ~ N(mean=110, sd=5)
# will center and scale
x_cognition <- scale(c(rnorm(n=34, mean=130, sd=5),
                 rnorm(n=22, mean=110, sd=5)),
                 center=TRUE,
                 scale=TRUE)
# create a model matrix
X <- model.matrix(~ x_scanner + x_time + x_cognition, #x_time:x_cognition
                  data=data.frame(x_scanner=x_scanner,
                             x_time=x_time,
                             x_cognition=x_cognition))
# set random seed
set.seed(3)
# generate the errors
error <- rnorm(n=56, mean=0, sd=1)
# generate the random subject effects
subject_effects <- rnorm(n=26, mean=0, sd=1)
subject <- c(rep(subject_effects[1:4], 3),
             rep(subject_effects[5:26], 2))
# generate the y's
Y <-  X %*% matrix(coefs) + subject + error

# create a data frame
df <- data.frame(id=x_ids,
                   scanner=x_scanner,
                   time=x_time,
                   cognition=x_cognition,
                   y=Y)
# create a delta_cog variable
df$delta_cog <- 0
df$delta_cog[35:56] <- df$cognition[35:56] - df$cognition[13:34]
cbind(df$time, df$delta_cog) # Q: Was this supposed to be saved into a variable?


# fit mixed model *without cognition*
fit <- lmer(y ~ scanner + time + (1|id), data=df)
# fit mixed model *with cognition*
fit_cog <- lmer(y ~ scanner + time + cognition + (1|id), data=df)
# fit mixed model *with delta cognition*
# fit_delta_cog <- lmer(y ~ scanner + time*delta_cog + (1|id), data=df)
# above model matrix is rank deficient, output only includes fixed effects
fit_delta_cog <- lmer(y ~ scanner + time + delta_cog + (1|id), data=df)

# compare results
summary(fit)
summary(fit_cog)
summary(fit_delta_cog)
