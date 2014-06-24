AdminController = RouteController.extend
  yieldTemplates:
    header:
      to: 'header'
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)

Router.map ->
  @route 'home',
    path: '/'
    data: ->
      episodes: Episode.all()

  @route 'episode',
    path: '/episode/:slug'
    data: ->
      Episode.first({slug: @params.slug})

  @route 'dashboard',
    path: '/admin'
    data: ->
      episodes: Episode.all()

  @route 'newPodcast',
    path: '/admin/episodes/new'
    data: ->
      new Episode

  @route 'editPodcast',
    path: '/admin/episodes/:slug'
    data: ->
      Episode.first({slug: @params.slug})

  @route 's3setup',
    path: '/admin/setup'

  if Meteor.isServer
    @route 'rss',
      where: 'server'
      path: '/rss'
      action: ->
        @response.write Meteor.call 'serveRSS'
        @response.end()

  @route 'download',
    where: 'server'
    path: '/download/:slug'
    action: ->
      episode = Episode.first({slug: @params.slug})
      episode.update({downloadCount: episode.downloadCount + 1})
      @response.writeHead '302', {Location: episode.url}
      @response.end()

  @route 'tests',
    path: '/tests'
    layoutTemplate: 'tests'

  @route 'notFound',
    path: '*'
    where: 'server'
    action: ->
      @response.statusCode = 404
      @response.end Handlebars.templates['404']()
