class VersionsController < MetadataController
  def create
    if service.update(service_params)
      metadata = service.latest_metadata

      render(
        json: MetadataSerialiser.new(service, metadata).attributes,
        status: :created
      )
    else
      render json: ErrorsSerializer.new(
        message: service.errors.full_messages
      ).attributes, status: :unprocessable_entity
    end
  end

  def previous
    metadata = service.metadata.by_locale(locale).previous_version

    render json: MetadataSerialiser.new(service, metadata).attributes, status: :ok
  end

  def latest
    metadata = service.metadata.by_locale(locale).latest_version
    render json: MetadataSerialiser.new(service, metadata).attributes, status: :ok
  end

  def index
    versions = service.metadata.by_locale(locale).all_versions.ordered

    render json: VersionsSerialiser.new(service, versions).attributes, status: :ok
  end

  def show
    metadata = service.metadata.find_by(id: params[:id])
    if metadata.nil?
      raise MetadataVersionNotFound, "Couldn't find Metadata Version with 'id'=#{params[:id]}"
    end

    render json: MetadataSerialiser.new(service, metadata).attributes, status: :ok
  end

  private

  # TODO: changing locale on the fly (with query param) is not fully implemented
  def locale
    @locale ||= params[:locale] || supported_locales
  end

  def supported_locales
    %w[en cy]
  end
end
