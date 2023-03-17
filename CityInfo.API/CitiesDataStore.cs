using CityInfo.API.Models;

namespace CityInfo.API;

public class CitiesDataStore
{
    public List<CityDto> Cities { get; set; }
    // public static CitiesDataStore Current { get; } = new CitiesDataStore();

    public CitiesDataStore()
    {
        Cities = new List<CityDto>()
        {
            new CityDto() {
                Id = 1,
                Name = "Hanoi",
                Description = "Vietnam's capital",
                PointsOfInterest = new List<PointOfInterestDto>() {
                    new PointOfInterestDto() {
                        Id = 1,
                        Name = "Ho Chi Minh mausoleum",
                        Description = "Crucial place in Hanoi"
                    },
                    new PointOfInterestDto() {
                        Id = 2,
                        Name = "Hoan Kiem lake",
                        Description = "Beautiful lake in Hanoi"
                    }
                }
            },
            new CityDto() {
                Id = 2,
                Name = "Saigon",
                Description = "Bigest city in Vietnam",
                PointsOfInterest = new List<PointOfInterestDto>() {
                    new PointOfInterestDto() {
                        Id = 3,
                        Name = "Landmark 81 building",
                        Description = "Tallest building in Vietnam"
                    },
                    new PointOfInterestDto() {
                        Id = 4,
                        Name = "Ben Thanh market",
                        Description = "Icon of Saigon"
                    }
                }
            },
            new CityDto {
                Id = 3,
                Name = "Danang",
                Description = "Cleanest city in Vietnam",
                PointsOfInterest = new List<PointOfInterestDto>() {
                    new PointOfInterestDto() {
                        Id = 5,
                        Name = "Dragon bridge",
                        Description = "Icon of Danang"
                    }
                }
            }
        };
    }
}
