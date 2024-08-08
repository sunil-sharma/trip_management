module Api
  module V1
    class TripsController < ApplicationController
      before_action :set_trip, only: [:show, :update, :check_in, :check_out, :reassign, :trip_versions]

      def index

        # Find all trip versions where the current user is the owner or assignee
        relevant_versions = TripVersion.where('owner_id = ? OR assignee_id = ?', current_user.id, current_user.id)

        # Extract trip IDs from these versions
        trip_ids = relevant_versions.pluck(:trip_id).uniq

        # Retrieve trips by these IDs
        trips = Trip.where(id: trip_ids).includes(:trip_versions)

        # Prepare response to include only relevant trip versions
        trips_with_filtered_versions = trips.map do |trip|
          trip_versions = trip.trip_versions.where(id: relevant_versions.pluck(:id))
          trip.as_json.merge(trip_versions: trip_versions)
        end

        render json: trips_with_filtered_versions

      end

      def trip_versions
        @trip_versions = @trip.trip_versions.where('owner_id = ? OR assignee_id = ?', current_user.id, current_user.id)
        render json: @trip.as_json.merge(trip_versions: @trip_versions.as_json)
      end

      def show
        render json: @trip.as_json(include: :trip_versions)
      end

      def create
        @trip = Trip.new(trip_params)
        @trip.status = 'Unstarted'

        if @trip.save
          TripVersion.create!(trip: @trip, owner: current_user, assignee: User.find(params[:trip][:assignee_id]))
          render json: @trip.as_json(include: :trip_versions), status: :created
        else
          render json: @trip.errors, status: :unprocessable_entity
        end
      end

      def update
        if @trip.update(trip_params)
          render json: @trip.as_json(include: :trip_versions)
        else
          render json: @trip.errors, status: :unprocessable_entity
        end
      end

      def check_in
        if @trip.check_in(current_user)
          render json: @trip.as_json
        else
          render json: { error: @trip.errors.full_messages.to_sentence }, status: :forbidden
        end
      end

      def check_out
        if @trip.check_out(current_user)
          render json: @trip.as_json
        else
          render json: { error: @trip.errors.full_messages.to_sentence }, status: :forbidden
        end
      end

      def reassign
        new_assignee = User.find(params[:new_assignee_id])

        unless new_assignee.present?
          render json: { error: "Invalid assignee" }, status: :unprocessable_entity
        end

        if @trip.reassign(current_user, new_assignee)
          render json: @trip.as_json, status: :created
        else
          render json: { error: @trip.errors.full_messages.to_sentence }, status: :forbidden
        end
      end

      private

      def set_trip
        @trip = Trip.find(params[:id])
      end

      def trip_params
        params.require(:trip).permit(:estimated_arrival, :estimated_completion)
      end
    end
  end
end
