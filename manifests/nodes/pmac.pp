# PowerPC (Mac Pro) on Jeff's network.
node 'pmac.internal.licquia.org' {

    include puppet

    include buildbot::slavechroot

}
