require 'spec_helper'
require 'codependent'

describe Codependent::Container do
  describe 'resolving a dependency' do
    it 'resolves a simple dependency' do
      Logger = Struct.new(:log_writer)

      container = Codependent::Container.new do
        singleton :logger do
          with_constructor { Logger.new }
        end
      end

      expect(container.resolve(:logger)).to be_a(Logger)
    end

    it 'resolves a nested dependency' do
      Logger = Struct.new(:log_writer)
      Repo = Struct.new(:logger)

      container = Codependent::Container.new do
        singleton :logger do
          with_constructor { Logger.new }
        end

        singleton :repo do
          with_constructor { Repo.new }
          depends_on :logger
        end
      end

      a_repo = container.resolve(:repo)

      expect(a_repo).to be_a(Repo)
      expect(a_repo.logger).to be_a(Logger)
    end

    it 'resolves a circular dependency' do
      RepoA = Struct.new(:repo_b)
      RepoB = Struct.new(:repo_a)

      container = Codependent::Container.new do
        singleton :repo_a do
          with_constructor { RepoA.new }
          depends_on :repo_b
        end

        singleton :repo_b do
          with_constructor { RepoB.new }
          depends_on :repo_a
        end
      end

      repo_a = container.resolve(:repo_a)

      expect(repo_a).to be_a(RepoA)
      expect(repo_a.repo_b).to be_a(RepoB)

      repo_b = container.resolve(:repo_b)

      expect(repo_b).to be_a(RepoB)
      expect(repo_b.repo_a).to be_a(RepoA)
    end
  end
end
